# Los lugares y las causas de muerte durante la pandemia en la CDMX 

En la carpeta ```codigo``` se alojan todos los scripts para poder replicar todos las graficas, así como el modelo segmentado.

En la carpeta ```datos``` se alojan todas las bases de datos empleadas en el análisis. 
* ```a_adip_adicionada.csv``` es la base de datos publicada por la ADIP de las actas defunción en el registro civil de la Ciudad de México con columnas adicionales sobre nuestra clasificación de causas de defunción. Consultada el 23 de marzo del 2021 [aquí](https://datos.cdmx.gob.mx/dataset/actas-de-defuncion-en-el-registro-civil-de-la-ciudad-de-mexico/resource/d683ec6e-171a-4825-a523-2cdbf30f9894).
* ```a_sedesa.csv``` es la versión validada por la SEDESA de la base de datos de las actas defunción en el registro civil de la Ciudad de México. Consultada el 23 de marzo del 2021 
[aquí](https://datos.cdmx.gob.mx/dataset/actas-de-defuncion-en-el-registro-civil-de-la-ciudad-de-mexico-version-validada-por-sedesa). 
* ```d_dge.csv``` es la base de datos de defunciones diarias por entidad reportadas por la DGE. Consultada el 22 de marzo del 2021 [aquí](https://datos.covid-19.conacyt.mx/#DownZCSV)
* ```defunciones_semanales.csv``` es la base de datos creada por nosotros que contiene: el total semanal de defunciones por covid-19 clasificadas por la ADIP y por nosotros (registradas en la base de datos ```a_adip_adicionada.csv```), y el exceso de mortalidad semanal (registrado en ```weeks.csv```). 
* ```h_sedesa.csv``` es la base de datos publicada por la SEDESA de personas hospitalizadas, confirmadas o sospechosas, por covid-19 en hospitales de la ZMVM. Consultada el 23 de marzo del 2021 [aquí](https://datos.cdmx.gob.mx/dataset/personas-hospitalizadas-en-hospitales-de-zmvm).
* ```weeks.csv``` es la base de datos actualizada el 7 de enero del 2021 de defunciones semanales por Romero Zavala, Mario & Despeghel, Laurianne. (2020). _Excess mortality data for Mexico City 2020._ Disponible [aquí](https://github.com/mariorz/folio-deceso/tree/ca38de22f649616cb54830f2d8e295e802efd326). 
* ```predicciones_modelo.csv``` es la base de datos creada por nosotros con la información empleada para el ajuste del modelo, así como las predicciones de este.

En la carpeta ```graficas``` se alojan todas las figuras en formato pdf, png y svg.

Finalmente, en el archivo ```taxonomia.txt``` se encuentra la taxonomía utilizada para clasificar las diferentes causas de muerte.



Ñ.