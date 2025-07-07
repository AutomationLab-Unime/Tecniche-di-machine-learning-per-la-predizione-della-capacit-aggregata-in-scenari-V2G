import pandas as pd
import numpy as np
from matplotlib import pyplot as plt

import tensorflow as tf
from tensorflow.keras.models import Model, Sequential,load_model
from tensorflow.keras.layers import Dense,LSTM,Input,Dropout,Input,Activation
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from tensorflow.keras.optimizers import Adam

from sklearn.preprocessing import StandardScaler

import sys

df = pd.read_csv("YearDataProcessedTable_vmh.csv")

print(df)

data = np.array(df.drop(columns=["start"]))

X_train = []
X_val = []
X_test = []

y_train = []
y_val = []
y_test = []

# Ogni riga equivale a 30 minuti, 1 giorno = 48 righe, 1 settinana = 336 righe, 1 mese = 1344 righe
# Il dataset e' composto di 54 settimane

X = []

for i in range(0,len(data),1344):

	month_window = data[i:i+1344]
	if len(month_window) == 1344:
		X.append(month_window)


X = np.array(X)

for i in range(len(X)):
	month = X[i]
	X_train.append(month[0:672])
	X_val.append(month[672:1008])
	X_test.append(month[1008:1344])


PREDICTION_STEP = 1
WINDOW = 48

X_train = np.array(X_train)
X_val = np.array(X_val)
X_test = np.array(X_test)

X_train = np.reshape(X_train,(-1,5))
X_val = np.reshape(X_val,(-1,5))
X_test = np.reshape(X_test,(-1,5))

#scaler = StandardScaler()
#X_train_scaled = scaler.fit_transform(X_train)
#X_val_scaled = scaler.transform(X_val)
#X_test_scaled = scaler.transform(X_test)

X_train = np.reshape(X_train,(-1,WINDOW,5))
X_val = np.reshape(X_val,(-1,WINDOW,5))
X_test = np.reshape(X_test,(-1,WINDOW,5))

#X_train_scaled = np.reshape(X_train_scaled,(-1,WINDOW,5))
#X_val_scaled = np.reshape(X_val_scaled,(-1,WINDOW,5))
#X_test_scaled = np.reshape(X_test_scaled,(-1,WINDOW,5))

y_train = X_train[:,PREDICTION_STEP:,0]
y_val = X_val[:,PREDICTION_STEP:,0]
y_test = X_test[:,PREDICTION_STEP:,0]

X_train = X_train[:,0:WINDOW-PREDICTION_STEP,:]
X_val = X_val[:,0:WINDOW-PREDICTION_STEP,:]
X_test = X_test[:,0:WINDOW-PREDICTION_STEP,:]

y_train = np.reshape(y_train,(-1,WINDOW-PREDICTION_STEP,1))
y_val = np.reshape(y_val,(-1,WINDOW-PREDICTION_STEP,1))
y_test = np.reshape(y_test,(-1,WINDOW-PREDICTION_STEP,1))


plt.figure()
plt.plot(X_train[0,:,0],label="input")
plt.plot(y_train[0,:],label="y")
plt.legend(loc="best")

plt.figure()
plt.plot(X_val[0,:,0],label="input")
plt.plot(y_val[0,:],label="y")
plt.legend(loc="best")

plt.figure()
plt.plot(X_test[0,:,0],label="input")
plt.plot(y_test[0,:],label="y")
plt.legend(loc="best")

plt.show()


print("X_train shape: ", X_train.shape)
print("X_val shape: ",X_val.shape)
print("X_test shape: ",X_test.shape)

print("y_train shape: ",y_train.shape)
print("y_val shape: ",y_val.shape)
print("y_test shape: ",y_test.shape)

inputs = Input(shape=(WINDOW-PREDICTION_STEP,5))
lstm = LSTM(units=176,return_sequences=True,activation="tanh")(inputs)
drop = Dropout(0.5611)(lstm)
#act = Activation("relu")(drop)
output = Dense(1,activation="linear",)(lstm)
lstm_model = Model(inputs=inputs, outputs=output)
lstm_model.compile(optimizer=Adam(learning_rate=0.0344),loss="mse")
lstm_model.summary()


history = lstm_model.fit(X_train,y_train,shuffle=True,epochs=1000,verbose=1,validation_data=(X_val,y_val),batch_size=8,
  callbacks = [EarlyStopping(monitor='val_loss', min_delta=0, patience=10, verbose=0, mode='min'),
	            ModelCheckpoint("lstm_v2g.keras",monitor='val_loss', save_best_only=True, mode='min', verbose=0)])


plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('Model Loss')
plt.ylabel('Loss')
plt.xlabel('Epoch')
plt.legend(['Train', 'Validation'], loc='upper left')
plt.show()


model = load_model("lstm_v2g.keras")
sample = X_test[0]
sample = np.reshape(sample,(1,WINDOW-PREDICTION_STEP,5))
pred = model.predict(sample)
print(pred.shape)
plt.plot(X_test[0,:,0],label="input")
plt.plot(y_test[0,:,0],label="y")
plt.plot(pred[0,:,0],label="prediction")
plt.legend(loc="best")
plt.show()


#sample = X_test[0]
#sample = np.reshape(sample,(1,WINDOW-PREDICTION_STEP,5))
#pred = model.predict(sample)
#print(pred.shape)
#for i in range(PREDICTION_STEP):
#	pred = model.predict(pred)
#plt.plot(pred)
