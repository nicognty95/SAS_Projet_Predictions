libname dossier '/home/u63325010/sasuser.v94/ProjetVRAI';
run;
/*IMPORTATION DE TOUTES LES DONNES*/
data DANONE;
set dossier.danone;
run;
proc sort data=DANONE;
by date;
run;

data CA;
set dossier.ca;
run;
proc sort data=CA;
by date;
run;

data LVMH;
set dossier.lvmh;
run;
proc sort data=LVMH;
by date;
run;

data ORANGE;
set dossier.orange;
run;
proc sort data=ORANGE;
by date;
run;

data OAT;
set dossier.oatt;
run;
proc sort data=OAT;
by date;
run;

data CARREFOUR;
set dossier.carrefour;
run;
proc sort data=CARREFOUR;
by date;
run;

data VINCI;
set dossier.vinci;
run;
proc sort data=VINCI;
by date;
run;

data AIRB;
set dossier.airbus;
run;
proc sort data=AIRB;
by date;
run;

data SANOFI;
set dossier.sanofi;
run;
proc sort data=SANOFI;
by date;
run;

data CAC40;
set dossier.cac40;
run;
proc sort data=CAC40;
by date;
run;


data INFLATION;
set dossier.inflation;
run;
proc sort data=INFLATION;
by date;
run;
data INFLATION2;
set INFLATION;
rendement_CARREFOURMOIS=12*dif1(carrefourMois)/lag1(carrefourMois);
rendement_INFLATION=12*dif1(inflation)/lag1(inflation);
run;

data VENTES;
set dossier.ventes;
run;


data INFLATION2;
set INFLATION;
rendement_CARREFOURMOIS=12*dif1(carrefourMois)/lag1(carrefourMois);
rendement_INFLATION=12*dif1(inflation)/lag1(inflation);
run;

data VENTES2;
set VENTES;
rendement_CARREFOURANNEE=dif1(carrefour)/lag1(carrefour);
rendement_VENTES=dif1(ventes)/lag1(ventes);
run;


/*FUSION DES DONNES DANS UNE TABLE*/
data data;
merge DANONE (in=ina) CA (in=inb) LVMH (in=inc) ORANGE (in=ind) OAT (in=ine) CARREFOUR (in=inf)
CAC40 (in=ing) VINCI (in=inh) AIRB (in=ini) SANOFI (in=inj);
by date;
if ine;
run;


data dataInflation;
merge CARREFOURMOIS (in=ina) INFLATION (in=inb);
by date;
if ine;
run;



/*CALCUL DU TAUX DE CROISSANCE ANNUEL*/
data data2;

set data;
rendement_DANONE=365*dif1(DANONE)/lag1(DANONE);
rendement_CA=365*dif1(CA)/lag1(CA);
rendement_LVMH=365*dif1(LVMH)/lag1(LVMH);
rendement_ORANGE=365*dif1(orange)/lag1(orange);
rendement_CARREFOUR=365*dif1(Carrefour)/lag1(Carrefour);
rendement_VINCI=365*dif1(VINCI)/lag1(VINCI);
rendement_AIRB=365*dif1(Airbus)/lag1(Airbus);
rendement_SANOFI=365*dif1(Close)/lag1(Close);
rendement_CAC_40=365*dif1(CAC)/lag1(CAC);
/*CONVERSION DE L'OAT en pourcentage*/
OAT=OAT/100;
/*CALCUL DU TAUX DE CROISSANCE NET DE L'ACTIF SANS RISQUE*/
rendement_net_DANONE=rendement_DANONE-OAT;
rendement_net_CA=rendement_CA-OAT;
rendement_net_LVMH=rendement_LVMH-OAT;
rendement_net_ORANGE=rendement_ORANGE-OAT;
rendement_net_CARREFOUR=rendement_CARREFOUR-OAT;
rendement_net_VINCI=rendement_VINCI-OAT;
rendement_net_AIRB=rendement_AIRB-OAT;
rendement_net_SANOFI=rendement_SANOFI-OAT;
rendement_net_CAC_40=rendement_CAC_40-OAT;
run;

/*CALCUL DES BETAS ET ALPHAS AVEC LES REGRESSIONS LINEAIRES*/
proc reg data=data2;
model rendement_net_DANONE = rendement_net_CAC_40;
model rendement_net_CA = rendement_net_CAC_40;
model rendement_net_LVMH = rendement_net_CAC_40;
model rendement_net_ORANGE = rendement_net_CAC_40;
model rendement_net_CARREFOUR = rendement_net_CAC_40;
model rendement_net_VINCI = rendement_net_CAC_40;
model rendement_net_AIRB = rendement_net_CAC_40;
model rendement_net_SANOFI = rendement_net_CAC_40;
run;

/*CREATION D'UN PORTEFEUILLE EQUIPONDERE AVEC LES 8 TITRES*/
data data4;
set data2;
rendement_net_P=(1/8)*(rendement_net_DANONE+rendement_net_CA
+rendement_net_LVMH+rendement_net_ORANGE+rendement_net_CARREFOUR +rendement_net_VINCI+rendement_net_AIRB+rendement_net_SANOFI);
run;

/*REGRESSION SUR CE PORTEFEUILLE*/
proc reg data=data4;
model rendement_net_p = rendement_net_CAC_40;
run;

/*CORRELATION ENTRE TOUTES LES VARIABLES*/
proc corr data=data4;
var rendement_net_VINCI rendement_net_AIRB rendement_net_LVMH rendement_net_SANOFI rendement_net_CA
rendement_net_CAC_40 rendement_net_DANONE rendement_net_CARREFOUR rendement_net_ORANGE;
run;

/*RECHERCHE DE FACTEURS EXTERNES EXPLICATIFS SUR CARREFOUR*/

/*REGRESSION SUR L'INFLATION*/
proc reg data=INFLATION2;
model  rendement_INFLATION = rendement_CARREFOURMOIS;
run;
/*REGRESSION SUR LES VENTES*/
proc reg data=VENTES2;
model  rendement_CARREFOURANNEE = rendement_VENTES;
run;

