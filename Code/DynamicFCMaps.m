
% Dynamic Fuzzy Cognitive Maps
clear all
clc
% Estado inicial de los conceptos
c=[1,1,1,0.5,1,1,1];
% Matriz de incidencia. Nivel de Expertos
w=[0.0 0.6 0.0 0.2 0.0 0.0 0.0
0.0 0.0 0.7 0.0 0.0 0.0 0.0
0.0 0.0 0.0 0.0 0.0 0.0 0.0
0.0 0.0 0.8 0.0 0.0 0.0 0.0
0.0 0.0 0.0 0.0 0.0 -0.3 0.6
0.0 0.0 0.0 0.0 0.0 0.0 0.0
0.0 -0.5 0.0 0.0 0.0 0.0 0.0];
% Tasa de aprendizaje
alfa=0.1;
% Actualizaci de conceptos y pesos
for k=1:5 %Bucle de 5 iteraciones para conceptos y pesos
    c1=c*w;
for i = 1:7 %Función de transferencia para actualizar conceptos
  if ((c1(i)> 0) && (c1(i)< 1))
     c1(i)= c1(i);
  else
  if c1(i)< 0
      c1(i) = 0;
  else 
     c1(i)=1;
     if c1(i) == 0
         c1(i) = 1;
     end
  end 
  end
end
for i = 1:7 % Aprendizaje hebbiano de conceptos
    for j = 1:7
        if i==j
            dw=0;
        else
          dci= c1(i)-c(i);
          dcj = c1(j)-c(j);
          if (dci * dcj)> 0
              dw = alfa*dci*dcj;
          else
              dw = 0;
          end
        w(i,j) = w(i,j)+ alfa*dw;
        end
    end
end
  c=c1;
  estados = c % estados finales de los conceptos
end
% Matriz de incidencia final. 
% Nivel de incidencia resultante entre conceptos
w 
