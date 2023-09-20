library(rstac)
library(gdalcubes)
source('https://gist.github.com/cboettig/5401bd149a2a27bde2042aa4f7cde25b/raw/d360b381f6e16ae518532ef1777116f175c471b5/ed_set_token.R')

# Set env vars EARTHDATA_USER and EARTHDATA_PASSWORD in your .Renviron or pass them manually to `ed_set_token()`
header <- ed_set_token()
gdalcubes_set_gdal_config("GDAL_HTTP_HEADERS", header)

gdalcubes_options(parallel = TRUE) 

# Set a search box in space & time
bbox <- c(xmin=-122.5, ymin=37.5, xmax=-122.0, ymax=38) 
start <- "2022-01-01"
end <- "2022-06-30"

# Find all assets from the desired catalog:
items <- stac("https://cmr.earthdata.nasa.gov/stac/LPCLOUD") |> 
  stac_search(collections = "HLSL30.v2.0",
              bbox = bbox,
              datetime = paste(start,end, sep = "/")) |>
  post_request() |>
  items_fetch() |>
  items_filter(filter_fn = \(x) {x[["eo:cloud_cover"]] < 20})

# 23 different features match search
length(items$features)

# RGB bands + mask
assets <- c("B02", "B03", "B04", "Fmask")
col <- stac_image_collection(items$features, asset_names = assets)

# Desired data cube shape & resolution
v = cube_view(srs = "EPSG:4326",
              extent = list(t0 = as.character(start), 
                            t1 = as.character(end),
                            left = bbox[1], right = bbox[3],
                            top = bbox[4], bottom = bbox[2]),
              nx = 512, ny = 512, dt = "P1M")

# use a cloud mask -- not sure I have this correct
# https://lpdaac.usgs.gov/documents/1326/HLS_User_Guide_V2.pdf
S2.mask <- image_mask("Fmask", values=1) # mask clouds and cloud shadows

rgb_bands <- c("B04","B03", "B02")

# Here we go! note eval is lazy
raster_cube(col, v) |>
  select_bands(rgb_bands) |>
  plot(rgb=1:3)

# using mask
# raster_cube(col, v, mask = S2.mask) |> select_bands(rgb_bands) |> plot(rgb=1:3)

