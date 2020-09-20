import pandas as pd
import sys
import time
try:
    if len(sys.argv)<2:
        raise Exception("No input file entered!")
    for i in range(1,len(sys.argv)):
        df=pd.read_csv(sys.argv[i])
        if len(df.columns)!=2:
            raise Exception("Input file should contain only two columns!")
        df.columns=["Roll No",sys.argv[i][:len(sys.argv[i])-4]]
        df.drop_duplicates("Roll No",keep="last",inplace=True)
        df.iloc[:,1].fillna(0,inplace=True)
        if i==1:
            df1=df.copy()
        else:
            df1=pd.merge(df1,df,how='outer',on='Roll No')
        df=df[df.iloc[:,1].apply(lambda x: str(x).isnumeric()==False)]
        df.insert(0,"File Name",sys.argv[i][:len(sys.argv[i])-4])
        df.columns=["File Name","Roll No","Marks"]
        if i==1:
            df2=df.copy()
        else:
            df2=df2.append(df)
    df1.fillna(0,inplace=True)
    df1.to_csv("result-"+str(time.time())+".csv",index=False)
    df2.to_csv("log-"+str(time.time())+".csv",index=False)
except FileNotFoundError:
    print("File Not Found!")
