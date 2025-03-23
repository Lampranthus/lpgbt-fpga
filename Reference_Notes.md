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



