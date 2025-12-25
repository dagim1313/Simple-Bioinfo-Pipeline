#########################################################
# BIOINFORMATICS QC PIPELINE (ROBUST VERSION)
#########################################################

# ----------------------------
# 1. SAFE PACKAGE LOADER
# ----------------------------

safe_load <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("[WARN] Package missing: ", pkg)
    message("       Some features may be disabled.")
    return(FALSE)
  }
  
  tryCatch({
    library(pkg, character.only = TRUE)
    return(TRUE)
  }, error = function(e) {
    message("[WARN] Failed to load: ", pkg)
    message("       Error: ", e$message)
    return(FALSE)
  })
}

# ----------------------------
# 2. PACKAGE INITIALIZATION (NON-FATAL)
# ----------------------------

bioc_packages <- c(
  "Biostrings",
  "ShortRead",
  "GenomicRanges",
  "VariantAnnotation",
  "rtracklayer"
)

loaded_pkgs <- list()

for (p in bioc_packages) {
  loaded_pkgs[[p]] <- safe_load(p)
}

message("\n=== PACKAGE STATUS ===")
print(loaded_pkgs)

# ----------------------------
# 3. CORE QC FUNCTION (ALWAYS WORKS)
# ----------------------------

run_fastq_qc <- function(fastq_file, output_dir = "fastq_qc_results") {
  
  message("\n[INFO] Starting FASTQ QC pipeline...")
  
  if (!file.exists(fastq_file)) {
    stop("FASTQ file not found: ", fastq_file)
  }
  
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # ----------------------------
  # BASIC FILE METRICS (NO BIOCONDUCTOR NEEDED)
  # ----------------------------
  
  file_size <- file.info(fastq_file)$size
  
  message("[INFO] File size: ", round(file_size / 1e6, 2), " MB")
  
  # ----------------------------
  # OPTIONAL BIOCONDUCTOR STEP
  # ----------------------------
  
  if (isTRUE(loaded_pkgs[["ShortRead"]])) {
    
    message("[INFO] Running ShortRead QC...")
    
    tryCatch({
      
      library(ShortRead)
      
      fq <- readFastq(fastq_file)
      
      qcs <- alphabetScore(fq)
      
      write.csv(
        data.frame(QC_score = qcs),
        file = file.path(output_dir, "quality_scores.csv"),
        row.names = FALSE
      )
      
      message("[INFO] ShortRead QC completed")
      
    }, error = function(e) {
      message("[WARN] ShortRead QC failed: ", e$message)
    })
    
  } else {
    message("[SKIP] ShortRead not available - skipping advanced QC")
  }
  
  # ----------------------------
  # OPTIONAL VARIANT STEP
  # ----------------------------
  
  if (isTRUE(loaded_pkgs[["VariantAnnotation"]])) {
    message("[INFO] VariantAnnotation available (variant analysis enabled)")
  } else {
    message("[SKIP] VariantAnnotation missing - variant analysis disabled")
  }
  
  # --------------   --------------
  # FINAL REPORT  
  # ----------------------------
  
  message("\n[INFO] QC pipeline finished")
  message("[INFO] Results saved in: ", output_dir)
  
  return(list(
    file = fastq_file,
    size_bytes = file_size,
    packages = loaded_pkgs,
    output_dir = output_dir
  ))
}

# ----------------------------
# 4. HELPER FUNCTION (STATUS CHECK)
# ----------------------------

check_pipeline_health <- function() {
  message("\n=== SYSTEM HEALTH CHECK ===")
  
  needed <- c("Biostrings", "ShortRead", "GenomicRanges")
  
  for (p in needed) {
    if (!requireNamespace(p, quietly = TRUE)) {
      message("Missing: ", p)
    } else {
      message("vailable: ", p)
    }
  }
}  










