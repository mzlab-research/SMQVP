
# SMQVP: Spatial Metabolomics Quality Visualization and Processing

## Introduction

SMQVP (Spatial Metabolomics data Quality Visualization and Processing) is a user-friendly web application designed for quality assessment and preprocessing of spatial metabolomics data. It provides a comprehensive solution for researchers to evaluate and enhance the reliability of their data through eight quality visualization points, including background consistency evaluation, noise ion filtering, intensity distribution analysis, and identification of isotopic and adduct ions.

## Features

- **Background Noise Removal**: Effectively identify and remove background pixels to improve data quality.
- **Noise Ion Filtering**: Detect and filter out noise ions that may interfere with spatial pattern recognition.
- **Intensity Distribution Analysis**: Visualize and analyze the distribution of pixel and ion intensities.
- **Missing Value Distribution**: Assess and visualize missing values at both pixel and ion levels.
- **Isotopic Peak Identification**: Identify isotopic peaks to evaluate the reliability of ion detection.
- **Adduct Ion Identification**: Accurately identify adduct forms of ions for subsequent identification processes.

## Getting Started

### Prerequisites

- R environment with Shiny package installed
- Spatial metabolomics peak table matrix data

### Installation

SMQVP is available as a web application and can be accessed directly through the following URL:

[SMQVP Online Platform](https://metax.genomics.cn/SMQVP)

Alternatively, you can download the source code from GitHub and install it locally if desired.

### Input Data Format

The input for SMQVP is a peak table matrix with the following structure:
- First two columns: X and Y coordinates of the pixels
- Subsequent columns: m/z values with corresponding intensities at each pixel

For detailed input data requirements, please refer to the tutorial panel within SMQVP.

## Usage

1. **Upload Data**: Upload your peak table matrix to SMQVP.
2. **Background and Tissue Region Selection**: Use the lasso tool to delineate background and tissue regions on the interaction image.
3. **Quality Visualization Points**:
   - **Spectra Examination**: Compare spectra profiles of selected regions.
   - **Background Consistency**: Evaluate the consistency of background regions.
   - **Ion Expression Proportion**: Determine the proportion of ions with higher expression in the tissue region.
   - **Noise Ion Detection**: Identify and filter noise ions.
   - **Intensity Distribution**: Visualize pixel and ion intensity distributions.
   - **Missing Value Distribution**: Assess missing values across different spatial regions and ions.
   - **Isotopic Peak Ratio**: Identify isotopic peaks and evaluate their spatial distribution consistency.
   - **Adduct Ion Ratio**: Search for and identify adduct ion pairs.
4. **Data Processing**: Follow the guided steps to complete the analysis and obtain preprocessed data.

## Example Data

The example data used in this study is spatial metabolomics data of a mouse brain acquired using the AFAD-ESI platform in positive ion mode. The data includes 53,812 pixels and 2,654 ion peaks. This peak table and raw data are available in the public repository [XXX](#).

## Results

SMQVP has been demonstrated to effectively improve clustering results by removing noise signals and enhancing data quality. The processed data aligns better with tissue morphology, highlighting the importance of thorough preprocessing in spatial metabolomics analysis.

## Conclusion

SMQVP addresses a critical gap in spatial metabolomics by providing a dedicated, user-friendly tool for standardized quality control and preprocessing. Its interactive visualization and automated processing functionalities lower technical barriers and promote reproducibility in research.

