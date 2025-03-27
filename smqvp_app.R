## app.R ##
library(shinydashboard)
library(ggplot2)
library(shiny)
library(shinythemes)
library(tidyverse)
library(reshape2)
library(pheatmap)
library(MetaboCoreUtils) #用于同位素和加和离子识别
library(spatstat)  #用于噪音检测
library(shinyjs)  # 用于提示消息
library(plotly) #用于绘制圈选图形
library(Seurat)

ui <- dashboardPage(
  dashboardHeader(title = "Spatial Metabolomics Quality Visualization and Processing",titleWidth = 550),
  
  dashboardSidebar(width = 350,
    sidebarMenu(
        menuItem("Tutorial", tabName = "Tutorial", icon = icon("dashboard")),
        menuItem("Data upload", tabName = "qc0", icon = icon("home")),
        menuItem("QVP1:spectrum checking", tabName = "qc1", icon = icon("th")),
        menuItem("QVP2: Background consistency", tabName = "qc2", icon = icon("th")),
        menuItem("QVP3: The ratio of ions higher in the tissue region", tabName = "qc3", icon = icon("th")),
        menuItem("QVP4: Noise ratio ", tabName = "qc4", icon = icon("th")),
        menuItem("QVP5: Intensity distribution", tabName = "qc5", icon = icon("th")),
        menuItem("QVP6: Missing value distribution", tabName = "qc6", icon = icon("th")),
        menuItem("QVP7: Isotope peak ratio", tabName = "qc7", icon = icon("th")),
        menuItem("QVP8: Adduct ion ratio", tabName = "qc8", icon = icon("th")),
        menuItem("Data download", tabName = "Download", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
        source(file.path("ui","U_Tutorial.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc0.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc1.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc2.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc3.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc4.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc5.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc6.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc7.R"),  local = TRUE)$value,
        source(file.path("ui","U_qc8.R"),  local = TRUE)$value,
        source(file.path("ui","U_Download.R"),  local = TRUE)$value
    )#tabItems
  )#dashboardBody
)#ui

server <- function(input, output) {
  options(shiny.maxRequestSize=1000*1024^2)
      source(file.path("server","S_Tutorial.R"),  local = TRUE)$value
      source(file.path("server","S_qc0.R"),  local = TRUE)$value
      source(file.path("server","S_qc1.R"),  local = TRUE)$value
      source(file.path("server","S_qc2.R"),  local = TRUE)$value
      source(file.path("server","S_qc3.R"),  local = TRUE)$value
      source(file.path("server","S_qc4.R"),  local = TRUE)$value
      source(file.path("server","S_qc5.R"),  local = TRUE)$value
      source(file.path("server","S_qc6.R"),  local = TRUE)$value
      source(file.path("server","S_qc7.R"),  local = TRUE)$value
      source(file.path("server","S_qc8.R"),  local = TRUE)$value
      source(file.path("server","S_download.R"),  local = TRUE)$value
}

shinyApp(ui, server)

