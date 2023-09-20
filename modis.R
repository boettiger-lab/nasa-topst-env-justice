library(rstac)
library(gdalcubes)
library(spData)
library(sf)
source('https://gist.githubusercontent.com/cboettig/5401bd149a2a27bde2042aa4f7cde25b/raw/ebed71fc1a0b3dac2ff1b426d6ef5bbd6528e146/edl_set_token.R')

# Auth settings
header <- edl_set_token()
gdalcubes_set_gdal_config("GDAL_HTTP_HEADERS", header)
gdalcubes_options(parallel = TRUE) 


CA <- spData::us_states |> dplyr::filter(NAME=="California")


bbox <- CA |> st_bbox()
start <- "2022-01-01"
end <- "2022-12-31"


items <- stac("https://cmr.earthdata.nasa.gov/stac/LPCLOUD") |> 
  stac_search(collections = "MOD13Q1.v061",
              bbox = c(bbox),
              datetime = paste(start,end, sep = "/")) |>
  post_request() |>
  items_fetch()

# HDF4 doesn't support cloud / VSI.  Download with auth:
paths <- edl_stac_urls(items) |>  purrr::map_chr(edl_download)

# Create collection using recognized format
col <- gdalcubes::create_image_collection(paths, format = "MxD13Q1")

# Define whatever view you like!
v = cube_view(srs = "EPSG:4326",
              extent = list(t0 = as.character(start), 
                            t1 = as.character(end),
                            left = bbox[1], right = bbox[3],
                            top = bbox[4], bottom = bbox[2]),
              nx = 512, ny = 512, dt = "P1M")
## Animation
raster_cube(col, v) |> 
  select_bands("NDVI") |> 
  animate(col = viridisLite::mako, fps=2)


# or layer + plot with familiar friend, tmap:
library(tmap)
r <- raster_cube(col, v) |> select_bands("NDVI") |> st_as_stars.cube()
tm_shape(r) + tm_raster("NDVI") + tm_shape(CA) + tm_borders()

