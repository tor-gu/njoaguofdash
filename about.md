## NJ OAG Use of Force Data Explorer

This is a simple dashboard to illustrate the use of the
[`njoaguof`](https://github.com/tor-gu/njoaguof) data package for R,
which is a repackaging of the the use of force data released by the [New
Jersey Office of the Attorney General](https://www.njoag.gov).

The NJ OAG has their own [dashboard](https://www.njoag.gov/force/). If
your interest is in gathering summary data for this dataset, you should
start there.

## About the data

### Current version

This site is based on `njoaguof` version 1.2.1, which contains data from
2020-10-01 through 2022-04-04.

### About the data

#### `incident` and `subject` tables

There are two main tables: `incident` and `subject`

The `incident` table contains one entry for every use of force report
filed by a law enforcement officer. Most incidents involve a single
officer and a single subject. However:

-   A single use of force report may refer to more than one subject of
    the use of force, and multiple types of force for each subject.
-   Multiple officers may file separate reports for the same incident.
-   Reports from different officers for the same incident may refer to
    exactly the same subjects, to different subjects, or to partially
    overlapping sets of subjects.

Because a single incident report may contain multiple subjects, the
subjects are broken out into a separate table.

Unfortunately, the underlying dataset does not allow us to disentagle
these potentially overlapping `incident`s and `subject`s. Thus, this
application counts every `incident` and every `subject` *separately*.
This means that the `incident` and `subject` counts are typically
*overcounts*. (The [NJ OAG dashboard](https://www.njoag.gov/force/)
makes the same decision.) However, see the special note on filtering
[multi-value `subject` fields](#subjectmulti), below.

#### Filtering on Single-Value and Multi-Value fields

Filtering may be done on either “single value” fields or on “multiple
value” fields.

A “single value” field may contain only one value for each incident
report. For example, there is only one value of `officer_gender` for
each `incident` and only one value of `arrested` for each `subject`.

Multi-value fields are fields in which the law enforcement officer may
select multiple values for a single field. For example, more than one
`location_type` (“Street”, “Business”, “Residence”, etc.) may be chosen
for a single `incident`.

This means that when filtereing on multi-value `incident` fields, the
“Relative” scale values may add up to more than 100% for a single
region.

##### Multi-value `subject` fields

There is an additional complexity with multi-value `subject` fields when
there are multiple subjects in the same incident report.

In some cases, incident reports with multiple subjects include separate
selections for each subject – for example, an incident report with
multiple subjects may contain the the `force_type` value “Used pressure
points on” twice, since it applies to two subjects in the incident
report.

In other cases, the incident report will only include a value once, even
if it applies to multiple subjects.

As a result, when filtering on multiple-value `subject` fields, the
filtered count may be either an *overcount* (because the same subject my
be included in multiple incident reports) or an *undercount* (because a
single value applied to multiple subjects).

In particular, this means that when filtereing on multi-value `incident`
fields, the “Relative” scale values may add up to either *more* or
*less* than 100% for a single region.

## About this site

This site is built with [shiny](https://shiny.rstudio.com/).

I used the [plotly](https://github.com/plotly/plotly.R) package for the
interactive map.

The table uses the [DT](https://rstudio.github.io/DT/) package.

The maps and the population data are from the US Census, obtained
through the [tigris](https://github.com/walkerke/tigris) and
[tidycensus](https://walker-data.com/tidycensus/index.html) packages,
respectively.

The source code is available
[here](https://github.com/tor-gu/njoaguofdash).
