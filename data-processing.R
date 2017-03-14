
fs_deposit_id <- 4707316
deposit_details <- fs_details(fs_deposit_id)

deposit_details <- unlist(deposit_details$files)
deposit_details <- data.frame(split(deposit_details, names(deposit_details)),stringsAsFactors = F)

gs_data <- read_csv(deposit_details[grepl("Suppl data 1 170228 PARV4 metadata file.csv",deposit_details$name),"download_url"])
# 
# gs_data <- read_csv("data/Suppl data 1 170228 PARV4 metadata file.csv")

# gs_data <-
#   read_csv(
#     "https://docs.google.com/spreadsheets/d/12MaZTQNlSDb7VQKAGmCLoZ01DuW2NpuEvsmbrF1UPGI/pub?gid=795511474&single=true&output=csv"
#   )
colnames(gs_data) <- make.names(tolower(colnames(gs_data)))

gs_data[gs_data == "No data"] <- NA
gs_data[gs_data == "Positive"] <- TRUE
gs_data[gs_data == "Negative"] <- FALSE
gs_data[gs_data == "Pending"] <- NA
gs_data[gs_data == "pending"] <- NA

gs_data <- gs_data %>%
  mutate(
    cd4..t.cell.count..cells.mm3. = as.numeric(cd4..t.cell.count..cells.mm3.),
    hiv.viral.load..rna.copies...ml. = as.numeric(hiv.viral.load..rna.copies...ml.)
  )


gs_data <- gs_data %>%
  rename(
    hiv.rna.copies = hiv.viral.load..rna.copies...ml.,
    cd4.t.cells = cd4..t.cell.count..cells.mm3.,
    adult.child = adult...child
  )

colnames(gs_data)
gs_data <- gs_data %>%
  mutate(
    hiv.status = recode(
      hiv.status,
      "TRUE" = "HIV positive",
      "FALSE" = "HIV negative",
      .missing = "NA"
    ),
    hbsag.status = recode(
      hbsag.status,
      "TRUE" = "HBsAg positive",
      "FALSE" = "HBsAg negative",
      .missing = "NA"
    ),
    hcv.rna.status = recode(
      hcv.rna.status,
      "TRUE" = "HCV RNA positive",
      "FALSE" = "HCV RNA negative",
      .missing = "NA"
    ),
    parv4.igg.status = recode(
      parv4.igg.status,
      "TRUE" = "PARV4 IgG positive",
      "FALSE" = "PARV4 IgG negative",
      .missing = "NA"
    ),
    parv4.dna.status = recode(
      parv4.dna.status,
      "TRUE" = "PARV4 DNA positive",
      "FALSE" = "PARV4 DNA negative",
      .missing = "NA"
    )
  )

## NAs have been converted to strings by recode
gs_data[gs_data == "NA"] <- NA

philippa_data <- gs_data
