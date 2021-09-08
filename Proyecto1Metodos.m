%% Universidad del Valle de Guatemala
%  Depto de Matematica
%  Metodos Numericos 1, seccion 30
%  Proyecto 1
%  Santiago Fernandez 18171
%  Camila Lemus 18272
%  Diego Mencos 18300
%  Larry Paul 18117
%  Daniel Barrientos 18714

close all
%% Datos de Prueba

test = 0; %Datos de prueba que cumplen con el modelo 
if (test)
    A = 4;
    k = -0.5;
    x = linspace(0,10,1000);
    f = 5.5;
    y = A*exp(k*x).*sin(2*pi*f*x);
end

%% Leyendo del csv

[t, data1, data2] = filter_data('./data.csv', 102, 5/23, 130, 255); %Lee los datos y los ingresa en arrays

data1 = data1 -5; %Centrar los datos en 0
data2 = data2 -5;

x = t'; %pasar los datos a 'x' y 'y'
y = data2';

x = x(1:55); % Recortar los arrays para quitar los datos inservibles
y = y(1:55);

%% Separando datos maximos
% Inicializamos 
y_ant = 0;
Ymax = [];
Xmax = [];
C = 1;
for n=1:(size(x,2)-1)
    switch C
        case 1
            if y_ant>y(n+1)
                Ymax = [Ymax y_ant];
                Xmax = [Xmax x(n)];
                C = 2;
            end
        case 2
            if y_ant<y(n+1)
                Ymax = [Ymax y_ant];
                Xmax = [Xmax x(n)];
                C = 1;
            end
    end
    y_ant = y(n+1);
end

Ymax(1) = abs(y(1)); % quick fix

figure(1)
scatter(x,y,20,'b','filled');
hold on
scatter(Xmax,Ymax,20,'r','filled')
hold off

%% Obteniendo frecuencia
%T_reg = 2*((max(Xmax)-min(Xmax))/(size(Xmax,2)-1));
T_reg = Xmax(5)-Xmax(3);
f_reg = 1/T_reg;
%f_reg = 31;

%% Linealizando el exponencial
Ymax = abs(Ymax); %Pasamos todos los picos negativos a la parte de arriba

Ymax(Ymax==0) = 0.2174; %fixes log(0) issue

Ylineal = log(Ymax); % Hallamos y* como ln(yi)

%Se plantean las matrices
MA = [size(Xmax,2) sum(Xmax); sum(Xmax) sum(Xmax.^2)];
MB = [sum(Ylineal);sum(Ylineal.*Xmax)];

Sol = MA\MB; %Esto es equivalente a A inversa por B

A_reg = exp(Sol(1)); %Obtenci�n de constantes de laa regresion
k_reg = Sol(2);

y_reg = A_reg*exp(k_reg*x).*(-cos(2*pi*f_reg*x)); %funcion obtenida de la regresi�n

%% R²
%Calculo de coeficiente de determinacion
Sr = sum((y-y_reg).^2); 

St = var(y)*size(y,2);

R_2 = 1-Sr/St;

%% Graficando original y regresion
figure(2)
plot(x,y,'-o');
hold on
plot(x,y_reg,'-x');
hold off
%% Calculos de componentes en circuito Salem-Key
u = 10^-6;
n = 10^-9;
C1 = 10*u; %Se propone valores iniciales para capacitores
C2 = 24*n;
Z = k_reg/sqrt(k_reg^2+(2*pi*f_reg)^2);
Wn = -k_reg/Z;
syms R1s R2s; %Se despeja para R1 y R2
S = solve([(R1s+R2s)/(R1s*R2s*C1)==2*Z*Wn, Wn^2==1/(R1s*R2s*C1*C2)],[R1s, R2s])

G = tf([Wn^2],[1 2*Wn*Z Wn^2])
figure(3)
step(5*G) %Se grafica la respuesta al escal�n de 5V de la funci�n de transferencia
R1 = double(S.R1s(2)); %Convertir datos de R1 y R2 a formato de numero
R2 = double(S.R2s(2));

%% Funciones

function [t, data1, data2] = filter_data(file, offset, scale, start_x, end_x)
    data_temp = readtable(file);
    
    t = 0:0.004:(size(data_temp.CH1, 1)-1)*0.004;
    t = t';
    
    t = t(1:(end_x - start_x + 1));
    
    data1 = (data_temp.CH1(start_x:end_x) - offset)*scale;
    data2 = (data_temp.CH2(start_x:end_x) - offset)*scale;

end
