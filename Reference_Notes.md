# lpgbt-fpga Reference Notes
Aqui escribiré las notas de lo que he realizado paso por paso.
---
Descargaré los archivos de lpgbt

https://gitlab.cern.ch/gbt-fpga/lpgbt-fpga
---
Simulé el active hdl el dowlink, las señales de Bypass son solo para el testeo, se ponen en '0'. Puse 32 bytes de tamaño de palabra. 

![image](https://github.com/user-attachments/assets/3173137a-712f-4883-8561-267a87a447c2)
---
Estas son las características de las señales,

![image](https://github.com/user-attachments/assets/15c30fc9-e1d6-43ca-8d3d-5b6ff6fb56dd)
---
Estoy intentando Simular el uplink pero no tengo éxito la señal rst_synch_s siempre tiene un valor desconocido, tengo la sospecha de que ese es el problema, estos son los valores que le puse a la simulacion y las caracteristicas de cada señal,

![image](https://github.com/user-attachments/assets/94102e95-dcc6-4421-aa8e-934c593817be)

![image](https://github.com/user-attachments/assets/a9517300-15e8-47c4-a7fc-9602ec16fc70)

![image](https://github.com/user-attachments/assets/46edf82b-f692-417b-a081-cc546901486c)
---
Ya pude simular el uplink, todo funcina bien, solo que la palabra que recibe debe terner cierto patron en los dos bits menos significativos, en este caso es "01" por lo que cambiando la mgt_word_i poniendo un 1 como bit menos significativo en hexadecimal cumple este patron ya que "0001", y esntonces la simulacion correnormalmnete, y si este no fuera el caso en el codigo lpgbtfpga_framealigner no se cumpliría nunca con sta_headerFlag_o        <= headerFlag_s WHEN (state = LOCKED or state = GOING_UNLOCK) ELSE '0'; lo que hace el rst_synch_s en el top del uplink nunca se definiera correctamente.
Este patron se puede cambiar en el uplink en la parte donde se llama a el framealigner.

---
Esta es la simulación del uplink

![image](https://github.com/user-attachments/assets/5cd7293f-efaf-4552-b8e5-3a8ff9b78ab6)
---
Ahora bien, para simular ambos bloques es necesario el bloque MGT por lo que lo tomaresmos de repositorio de lpgbt-fpga-simulation,

![image](https://github.com/user-attachments/assets/ae20fa2c-622c-427a-a86d-e5c65bfcee93)

![image](https://github.com/user-attachments/assets/5885bb78-21cf-434d-94f6-4dafade5bef6)
---
Simulando el bloque MGT con valores obtenidos del test bench,

![image](https://github.com/user-attachments/assets/b354d496-b923-4a0d-a0c4-4de348976240)
---
Ahora quiero simular el questa el lpgbt model que me dieron, descargue quartus prime lite que viene con questa fse pero para abrir questa tienes que primero abrir quartus ir a tools, lecense setup y get no-cost licenses, seleccionas la opcion de questa y te creara un archivo .dat que tienes que agregar al path de windows en variables de entorno, creas una nueva variable del sistema y la llamas LM_LICENSE_FILE con el valor de la direccion de archivo .dat, en mi caso C:/Users/Lampranthus/quartus2_lic.dat.
Ahora se puede abrir questa fse.

---
Me pasé a la versión de questa fpga edition, solo agregé la licencia al momento de descargar la licencia de quartus y realizando el mismo paso anteriror de poner la linecia en el path pude abrir questa fpga edition.

---
Me pasarón los archivos de lpgbt-fpga-simulation donde contiene el modelo del lpgbt, simulé en model-sim pero no pude hacer que la simulación de 1500us se guardará para poder reanudar la simulación y no tener que esperar las aproximadamente 12 horas que tarda la simulación, investigué y regresé al questa-sim donde puedo usar la función checkpoint para guardfar el progreso de la simulación, solo que para que la simulación se ejecute tienen que suprimir algunos errores que te arroja en questa ya que las instáncias que permite la versión son 5000 y el modelo del lpgbt tiene mas de 12mil por lo que te arroja un error, si suprimes estos errores el programa te dice que el proceso será unas 30 veces más lento pero por laguna razón aún así es mucho más rápido que el questa-sim por lo que no hay problema.

---
Estos una vez tieniendo todos los archivos del repositorio lpgbt-fpga-simulation y el questa-sim en este caso la versión fpga 2024.3, para poder iniciar la simulación tenemos que cambiar una linea del script testbench.tcl.

---
Abrimos el script para podemor editar y en la parte de la función simulation cambiamos:
```
eval vsim -voptargs=+acc=lprn work.top_tb -gFEC=$fec -gDATARATE=$datarate -t 1ps -suppress vopt-7063
```    
por,
```
eval vsim -voptargs=+acc=lprn work.top_tb -gFEC=1 -gDATARATE=2 -t 1ps -suppress vopt-7063 -suppress vopt-10908 -suppress vopt-14408
```
y guardamos el archivo tcl.

---
Ahora bien ya podemos seguir las instrucciónes del readme del repositorio de git lab:

1. Abrimos, en este caso questa intel fpga edition 2024.3)
2. Nos movemos a la carpeta lpgbt-fpga-simulation
3. Ejecutamos los siguientes comandos
```
source TCL/testbench.tcl
compile_project
simulate 1 2
downlink_reset
lpgbt_reset
uplink_reset
run 1500 us
```
4. Esperamos a que la simulación termine, esto puede durar varias horas.

Observación: en comando simulate el primer numero es para seleccionar el FEC y el segundo es para seleccionar el DATARATE ( para la FEC; 1 = FEC5, 2 = FEC12 y para el DATARATE; 1 = 5G, 2 = 10G)

---
Una vez pasados los 1500 us, puedes guardar el progreso de la simulación con los comandos

- checkpoint nombre_del_archivo

Esto creará un archivo .cpt con ese nombre, con el cual vas a poder regresar sin necesidad de volver a simular los los primerlos 1500us.

Si aún no haz detenido la simulación puedes regresar a este check point con el comando:

- restore nombre_del_archivo.cpt

pero si la simulación ya se detuvo se tiene que utilizar el comando:

- vsim -restore nombre_del_archivo.cpt

Esto es estando dentro de la carpeta donde se encuentra el archivo.

---
Una vez en este punto podemos hacer algunas cosas en la simulación gracias al script.
La simulación debe llegar hasta este punto ya que el modelos del lpgbt nos dice que el asic está listo a los caso 1400us y de este punto ya está listo para poder jugar con los comandos de uplink y downlink y ver como el sistema realcciona.

---



