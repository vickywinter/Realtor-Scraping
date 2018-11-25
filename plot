#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 23 13:56:55 2018

@author: vickywinter
"""
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.dates as mdates

realtor=pd.read_csv('/Users/vickywinter/Documents/NYC/Scrapy/Realtor/Realtor/Realtor_listing_Nov_clean.csv')
realtor.describe()

realtor['area_ft']=realtor['area_ft'].str.replace(',','')
realtor['area_ft']=realtor['area_ft'].astype(int)

realtor['lot_ft']=realtor['lot_ft'].str.replace(',','')
realtor['lot_ft']=realtor['lot_ft'].astype(float)
realtor['lot_ft']=realtor['lot_ft'].apply(lambda x: x*43560 if x<10 else x)

realtor['price_ft']=realtor['price_ft'].str.replace(',','')
realtor['price_ft']=realtor['price_ft'].astype(float)

for i in range(1,4):
    i=str(i)
    realtor['school' + i]=realtor['school' + i].apply(lambda x: None if x=='NR' else float(x))
    
realtor['highest_scho']=realtor[['school1','school2','school3']].max(axis=1)
realtor['lowest_scho']=realtor[['school1','school2','school3']].min(axis=1)
realtor=realtor.drop(columns=['school1','school2','school3'])

realtor['sold_date']=pd.to_datetime(realtor['sold_date'],format='%d-%b-%y').dt.date


missing_value=pd.DataFrame({'miss':realtor.isnull().sum(),'ratio':(realtor.isnull().sum() / len(realtor)) * 100})
realtor['bath_full']=realtor['bath_full'].fillna(0)
realtor['bath_half']=realtor['bath_half'].fillna(0)
realtor['beds']=realtor['beds'].fillna(0)
realtor['highest_scho']=realtor['highest_scho'].fillna(5)
realtor['lowest_scho']=realtor['lowest_scho'].fillna(5)

realtor["days_on_market"]=realtor["days_on_market"].fillna(realtor["days_on_market"].median())
realtor["lot_ft"]=realtor["lot_ft"].fillna(realtor["lot_ft"].median())

realtor=realtor[realtor['price_ft']<3000]

corrmat = realtor.corr()
plt.subplots(figsize=(12, 9))
sns.heatmap(corrmat, vmax=.8, square=True);



a=pd.DataFrame(realtor.groupby('sold_date')['price_ft'].mean())
plt.plot(a.index,a['price_ft'])

b=pd.DataFrame(realtor.groupby('sold_date')['price_ft'].median())
plt.plot(b.index,b['price_ft'])



pl=sns.boxplot(x=realtor['zip_code'],y=realtor['price_ft'])
pl.set_xticklabels(pl.get_xticklabels(), rotation=40, ha="right")

sns.boxplot(x=realtor['highest_scho'],y=realtor['price_ft'])
sns.boxplot(x=realtor['lowest_scho'],y=realtor['price_ft'])

ab=sns.boxplot(x=realtor['property_type'],y=realtor['price_ft'])
ab.set_xticklabels(ab.get_xticklabels(), rotation=40, ha="right")