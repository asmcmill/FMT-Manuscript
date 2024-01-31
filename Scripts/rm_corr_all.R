require(rmcorr)


rmcorr_test<-function(metadata,pid,df1,df2,p.adjust.method){
  
  if(all(sapply(list(rownames(df1),rownames(df2)),function(x) x==rownames(metadata)))){
    
    data<-cbind(metadata,df1,df2)
    
    rmcor<-NULL
    for (i in colnames(df1)){
      for (x in colnames(df2)){
        tryCatch({
          cor<-rmcorr(participant=get(pid),measure1=get(x),measure2=get(i),dataset=data)
        }, warning=function(w){}
        )
        
        temp<-data.frame(i,x,cor$r,cor$p)
        rmcor<-rbind(rmcor,temp)
      }
    }
    rmcor["p.adj"]<-p.adjust(rmcor$cor.p, method=p.adjust.method) 
    names(rmcor)<-c("df1","df2","r","p","p.adj")
    return(rmcor)
  }else{
    warning("Rownames of inputs must match")
  }
}