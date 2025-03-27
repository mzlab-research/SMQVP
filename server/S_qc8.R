
observeEvent(input$mode_select, {
  positive_ions <- adductNames(polarity = "positive")
  negative_ions <- adductNames(polarity = "negative")
  mode <- input$mode_select
  if (mode == "pos") {
    updateSelectInput(session = getDefaultReactiveDomain(), "adduct_ion", choices = positive_ions,selected = positive_ions[c(13,16,18,20,36)])
  } else if (mode == "neg") {
    updateSelectInput(session = getDefaultReactiveDomain(), "adduct_ion", choices = negative_ions,selected = negative_ions[c(3,5)])
  }
})



adduct_ion_table <- reactive({
  sp4 <- peakData_remove_noise()
  add_neg <- input$adduct_ion
  sp4[is.na(sp4)] <- 0.1
  mz <- as.numeric(names(sp4)[-c(1,2)])
  names(mz) <- mz

  combinations <- combn(add_neg, 2, simplify = FALSE)
  
  add_all <- NULL
  for(x in c(1:length(combinations))){
    i <- combinations[[x]]
    mz_add <- as.data.frame(mz2mass(mz, i))
    mz_add$mz <- row.names(mz_add)
    mz_add <- melt(mz_add,ic=c("mz"),variable.name = "adduct",value.name = "netural_mass")
    neutral_mass <- mz_add$netural_mass
    names(neutral_mass) <- paste(mz_add$mz,mz_add$adduct,sep = "_")
    diff_mz <- outer(neutral_mass, neutral_mass, function(a, b) abs((a - b) / b*1e6))
    diag(diff_mz) <- 10
    diff_mz_compare <- diff_mz<5
    true_indices1 <- which(diff_mz_compare, arr.ind = TRUE)
    if(nrow(true_indices1)>0){
      adduct_cor <- apply(true_indices1,1,function(x){
        a <- mz_add[x[1],1]
        b <- mz_add[x[2],1]
        k <- which(names(sp4) %in% c(a,b))
        if(length(k)==2){
          return(cor(sp4[,k[1]],sp4[,k[2]]))
        }else{
          return(1)
        }
        
      })
      true_indices2 <- as.data.frame(cbind(true_indices1,adduct_cor))
      true_indices2 <- true_indices2[true_indices2$adduct_cor>0.6,]
      if(nrow(true_indices2)>0){
        mz_add$mark <- "unpair"
        for(j in c(1:nrow(true_indices2))){
          a <- true_indices2[j,1]
          b <- true_indices2[j,2]
          mz_add$mark[c(a,b)] <- paste("Two",x,j,sep = "_")
        }
        mz_add2 <- mz_add[mz_add$mark != "unpair",]
        mz_add2 <- mz_add2[order(mz_add2$mark),]
        add_all <- rbind(add_all,mz_add2)
      }
    }
  }
  add_all$test <- paste(add_all$adduct,add_all$mark)
  d <- which(duplicated(add_all$test)==TRUE)
  add_all2 <- add_all[!(add_all$test %in% add_all$test[d]),]
  mz_add_nu <- aggregate(add_all2$adduct,by=list(add_all2$mz),function(x){
    length(unique(x))
  })
  unknow_mz <- mz_add_nu$Group.1[which(mz_add_nu$x>1)]
  unknown_mark <- add_all2$mark[add_all2$mz %in% unknow_mz]
  add_all2 <- add_all2[!(add_all2$mark %in% unknown_mark),]
  names(add_all2)[4] <- "adduct_mark"

  add_all2$mz_adduct <- paste(add_all2$mz,add_all2$adduct)
  add_all2$duplicated <- duplicated(add_all2$mz_adduct) | duplicated(add_all2$mz_adduct, fromLast = TRUE)
  d2 <- which(add_all2$duplicated ==TRUE)
  du_mz <- unique(add_all2$mz_adduct[add_all2$duplicated == TRUE])
  du_remove <- NULL
  for(j in c(1:length(du_mz))){
    i <- du_mz[j]
    row_nu <- which(add_all2$mz_adduct == i)
    marks <- add_all2$adduct_mark[row_nu]
    add_all2$adduct_mark[which(add_all2$adduct_mark %in% marks)] <- paste("Multiple_3_",j,sep = "")
    du_remove <- c(du_remove,row_nu[-1])
  }
  add_all3 <- add_all2[-du_remove,]
  adduct_mark <- unique(add_all3$adduct_mark)
  for(i in adduct_mark){
    k <- which(add_all3$adduct_mark %in% i)
    sub_add <- add_all3[k,]
    netural <- mean(sub_add$netural_mass)
    add_all3$netural_mass[k] <- netural
  }
  
  return(add_all3[,-c(5,6,7)])
  
})


output$adduct_ratio_box <- renderInfoBox({
  data <- peakData_remove_noise()
  adduct <- adduct_ion_table()
  
  k <- nrow(adduct)/ncol(data)
  
  infoBox(
    "The ratio of adduct peaks is:",sprintf("%.2f%%", k * 100), icon = icon("list"),
    color = "purple"
  )
})


output$adduct_peaks_count <- renderPlot({
  add_all2 <- adduct_ion_table()
  add_count <- as.data.frame(table(add_all2$adduct))
  colnames(add_count) <- c("adduct", "Frequency")
  add_plot <- ggplot(add_count, aes(x = adduct, y = Frequency)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    theme_bw() +
    coord_flip()
  return(add_plot)
})


