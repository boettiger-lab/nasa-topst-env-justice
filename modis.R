library(rstac)
library(gdalcubes)
source('https://gist.github.com/cboettig/5401bd149a2a27bde2042aa4f7cde25b/raw/d360b381f6e16ae518532ef1777116f175c471b5/ed_set_token.R')
header <- ed_set_token()
gdalcubes_set_gdal_config("GDAL_HTTP_HEADERS", header)

gdalcubes_options(parallel = TRUE) 

library(spData)
library(sf)
CA <- spData::us_states |> dplyr::filter(NAME=="California")
bbox <- CA |> st_bbox()

box = CA |> vect() |> ext()

start <- "2022-07-01"
end <- "2022-07-31"
#test STAC
items <- stac("https://cmr.earthdata.nasa.gov/stac/LPCLOUD") |> 
  stac_search(collections = "MOD13Q1.v061",
              bbox = c(bbox),
              datetime = paste(start,end, sep = "/")) |>
  post_request() |>
  items_fetch()


library(httr)
localize <- function(x) {
  dest <- basename(x)
 bearer <- gsub("Authorization: ", "", header)
  httr::GET(href, 
            httr::write_disk(dest, overwrite = TRUE),
            httr::add_headers(Authorization= bearer)
            #httr::authenticate(Sys.getenv("EARTHDATA_USER"),
            #                   Sys.getenv("EARTHDATA_PASSWORD"))
            )
  dest
}

## proof-of-concept
href <- items$features[[15]]$assets$data$href
x <- terra::rast(localize(href))
#library(stars)
#read_stars(paths[[15]]) |> plot()
rast(paths, 1) |> terra::project("EPSG:4326") |> crop(box) |>  plot()


paths <- purrr::map_chr(items$features, list("assets", "data", "href")) |>
  purrr::map_chr(localize)
col <- gdalcubes::create_image_collection(paths, format = "MxD13Q1")
# col <- stac_image_collection(items$features, asset_names = "data",  url_fun = localize)

v = cube_view(srs = "EPSG:4326",
              extent = list(t0 = as.character(start), 
                            t1 = as.character(end),
                            left = bbox[1], right = bbox[3],
                            top = bbox[4], bottom = bbox[2]),
              nx = 512, ny = 512, dt = "P1M")

raster_cube(col, v)|> plot()

r <- raster_cube(col, v) |> select_bands("NDVI") |> st_as_stars()
library(tmap)
tm_shape(CA) + tm_polygons() + tm_shape(r) + tm_raster("NDVI")

library(terra)
terra::rast("test/cube_1ac2ea680dc2018-06-01.tif") 
