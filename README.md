![Project_Funding_Logo](https://github.com/user-attachments/assets/767fa159-4f61-4f93-aa0d-682375f72f59)

LA 2.13

Realizzazione di modelli interpretabili basati su tecniche di Machine 
learning per la predizione della capacità aggregata fornita da veicoli 
elettrici a supporto delle esigenze della rete elettrica

Responsabile Linea di Attività
Prof. Luca Patanè
Università degli Studi di Messina (UniME)

Titolo 
RT-1.02-2.13-1
Analisi ed implementazione di tecniche di machine learning per la 
realizzazione di modelli interpretabili per la predizione della capacità 
aggregata disponibile fornita da veicoli elettrici a supporto della rete 
elettrica

Tecniche di machine learning per la predizione della capacit aggregata in scenari V2G

README - V2G Modeling Framework GUI
Questa interfaccia grafica MATLAB consente il caricamento, l'esplorazione, la modellazione e l'analisi avanzata dei dati per il progetto V2G (Vehicle-to-Grid).
1. Uso dell'interfaccia
La GUI è divisa in diversi pannelli funzionali:
•	• Load Data
•	• Data Exploration
•	• Model Library
•	• Advanced Analysis
•	• Documentation
2. Caricamento dei Dati (Panel: Load Data)
Permette di caricare i dati di input per veicoli e ingressi esogeni.
2.1 Vehicle Data
Dataset	Formato	Percorso
Rome	*.mat	Data\Rome\RawData\
Padua	*.mat	Data\Padua\PDX_*/ (es. PD1_15_10_2018)
VED	*.csv	Data\VED\RawData\171101\
2.2 Exogenous Data
Dataset	Grandezze	Formato	Percorso
Rome	Meteo/Calendar	*.mat	Data\Rome\Meteo Data\
Padua	Traffic	*.mat	Data\Padua\Traffico ingresso\
VED	Meteo/Calendar	*.mat	Data\VED\RawData\Meteo_AAC.mat
3. Esplorazione Dati (Panel: Data Exploration)
Comprende due strumenti principali:
•	• Stop Maps Visualization: rappresentazione geografica delle soste
•	• Timeseries Visualization: serie temporali degli ingressi (traffico/meteo) e target AAC, studio della correlazione tra inputs e output del modello
4. Libreria Modelli (Panel: Model Library)
Contiene i modelli predittivi suddivisi per dataset:
•	• Rome: Linear e Nonlinear Models in ambiente Matlab
•	• Padua: LSTM in ambiente Python
•	• VED: HDMDc in ambiente Python
5. Analisi Avanzata (Panel: Advanced Analysis)
Strumenti integrati per analisi avanzate:
•	• Interpretability: interpretazione del modello (es. SHAP) in ambiente Matlab
•	• Transferability: trasferimento del modello (fine-tuning) in ambiente Python
6. Documentazione (Panel: Documentation)
Link a documenti informativi:
•	• ReadMe (questo documento)
•	• Dataset Doc
•	Rome: Documento di Classificazione delle zone di interesse
•	VED pubblicazione che descrive dettagliatamente i dati
•	• Publications (cartella con pubblicazioni colle

