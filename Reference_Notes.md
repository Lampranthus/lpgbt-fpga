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


