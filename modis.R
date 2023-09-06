library(rstac)
library(gdalcubes)
source('https://gist.github.com/cboettig/5401bd149a2a27bde2042aa4f7cde25b/raw/d360b381f6e16ae518532ef1777116f175c471b5/ed_set_token.R')
header <- edl_set_token()
gdalcubes_set_gdal_config("GDAL_HTTP_HEADERS", header)

gdalcubes_options(parallel = TRUE) 

library(spData)
library(sf)
CA <- spData::us_states |> dplyr::filter(NAME=="California")
bbox <- CA |> st_bbox()

#library(terra)
#box = CA |> vect() |> ext()

start <- "2022-07-01"
end <- "2022-07-31"
#test STAC
items <- stac("https://cmr.earthdata.nasa.gov/stac/LPCLOUD") |> 
  stac_search(collections = "MOD13Q1.v061",
              bbox = c(bbox),
              datetime = paste(start,end, sep = "/")) |>
  post_request() |>
  items_fetch()


paths <- edl_stac_urls(items) |> purrr::map_chr(edl_download)


col <- gdalcubes::create_image_collection(paths, format = "MxD13Q1")
#col <- stac_image_collection(items$features, 
#                             asset_names = "data", 
#                             url_fun = edl_download)

v = cube_view(srs = "EPSG:4326",
              extent = list(t0 = as.character(start), 
                            t1 = as.character(end),
                            left = bbox[1], right = bbox[3],
                            top = bbox[4], bottom = bbox[2]),
              nx = 512, ny = 512, dt = "P1M")

raster_cube(col, v)|> select_bands("NDVI") |> plot()

r <- raster_cube(col, v) |> select_bands("NDVI") |> st_as_stars.cube()
library(tmap)
tm_shape(r) + tm_raster("NDVI") + tm_shape(CA) + tm_borders()

