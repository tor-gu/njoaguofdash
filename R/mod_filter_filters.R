filters <- tibble::tribble(
  ~table,     ~filter,                    ~display_name,              ~join_table, ~filter_column,

  ### incident table
  "incident", "all",                      "All Incidents",            NA, NA,
  ### incident single value
  "incident", "agency_county",            "Agency County",            NA, "agency_county",
  "incident", "agency_name",              "Agency Name",              NA, "agency_name",
  "incident", "officer_race",             "Officer Race",             NA, "officer_race",
  "incident", "officer_gender",           "Officer Gender",           NA, "officer_gender",
  "incident", "officer_injured",          "Officer Injured",          NA, "officer_injured",
  "incident", "video_footage",            "Video Footage",            NA, "video_footage",
  "incident", "indoors",                  "Indoors",                  NA, "indoors",
  "incident", "outdoors",                 "Outdoors",                 NA, "outdoors",
  "incident", "subject_count",            "Subject Count",            NA, "subject_count",
  ### incident multi-value
  "incident", "contact_origin",           "Contact Origin",           "incident_contact_origin", "contact_origin",
  "incident", "lighting",                 "Lighting",                 "incident_lighting", "lighting",
  "incident", "location_type",            "Location Type",            "incident_location_type", "location_type",
  "incident", "officer_injury_type",      "Officer Injury Type",      "incident_officer_injury_type", "officer_injury_type",
  "incident", "officer_medical_treatment","Officer Medical Treatment","incident_officer_medical_treatment", "officer_medical_treatment",
  "incident", "planned_contact",          "Planned Contact",          "incident_planned_contact", "planned_contact",

  ### subject table
  "subject",  "all",                       "All Subjects",            NA, NA,
  ### subject single value
  "subject",  "arrested",                  "Arrested",                NA, "arrested",
  "subject",  "type",                      "Type",                    NA, "type",
  "subject",  "juvenile",                  "Juvenile",                NA, "juvenile",
  "subject",  "race",                      "Subject Race",            NA, "race",
  "subject",  "gender",                    "Subject Gender",          NA, "gender",
  ### subject multi-value
  "subject",  "action",                    "Subject Action",          "incident_subject_action", "subject_action",
  "subject",  "force_type",                "Force Type",              "incident_subject_force_type", "force_type",
  "subject",  "subject_injury",            "Subject Injury",          "incident_subject_injury", "subject_injury",
  "subject",  "subject_medical_treatment", "Subject Medical Treatment","incident_subject_medical_treatment", "subject_medical_treatment",
  "subject",  "perceived_condition",       "Perceived Condition",     "incident_subject_perceived_condition", "perceived_condition",
  "subject",  "reason_not_arrested",       "Reason Not Arrested",     "incident_subject_reason_not_arrested", "reason_not_arrested",
  "subject",  "subject_resistance",        "Subject Resistance",      "incident_subject_resistance", "subject_resistance",
)
