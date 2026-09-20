# njoaguofdash 2.0.0

* Breaking changes:
  - Requires `njoaguof (>= 2.0.0)` and `R (>= 4.1)`.

* Time range for per-capita calculations no longer hard-coded.

* Census data refreshed:
  - Use the 2024 population estimates (replacing 2019).
  - Use 2024 TIGER municipal boundaries. (So Pine Valley is removed.)
  - `data-raw/internal_data.R` rewritten so that it no longer requires a Census API key.  

* Package dependencies and remotes reworked as part of general cleanup. Removed build-time dependency on `tidycensus`.

* Development environment is now managed with `renv`.

* Added a runnable `app.R` and a `Dockerfile` for deployment.

# njoaguofdash 1.0.0

* Initial public version.
