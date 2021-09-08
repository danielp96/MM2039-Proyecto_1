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
%% Extrayendo Datos del CSV
test = 0;
if (test)
    A = 4;
    k = -0.5;
    x = linspace(0,10,1000);
    f = 5.5;
    y = A*exp(k*x).*sin(2*pi*f*x);
end

%% Leyendo del csv

[t, data1, data2] = filter_data('./data.csv', 102, 5/23, 130, 255);

data1 = data1 -5;
data2 = data2 -5;

x = t';
y = data2';

x = x(1:55);
y = y(1:55);

%% Separando datos maximos
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


plot(Xmax,abs(Ymax),'-x')
hold on
plot(t, abs(data2));
hold off

%% Obteniendo frecuencia
%T_reg = 2*((max(Xmax)-min(Xmax))/(size(Xmax,2)-1));
T_reg = Xmax(5)-Xmax(3);
f_reg = 1/T_reg
%f_reg = 31;

%% Linealizando el exponencial
Ymax = abs(Ymax);

Ymax(Ymax==0) = 0.2174; %fixes log(0) issue

Ylineal = log(Ymax);
MA = [size(Xmax,2) sum(Xmax); sum(Xmax) sum(Xmax.^2)];
MB = [sum(Ylineal);sum(Ylineal.*Xmax)];

Sol = MA\MB;

A_reg = exp(Sol(1));
k_reg = Sol(2);

y_reg = A_reg*exp(k_reg*x).*(-cos(2*pi*f_reg*x));

%% R²

Sr = sum((y-y_reg).^2);

St = var(y)*size(y,2);

R2 = 1-Sr/St;

%% Graficando original y regresion
figure(3)
plot(x,y,'-o');
hold on
plot(x,y_reg,'-x');
%% Tomando puntos maximos


%% Funciones

function [t, data1, data2] = filter_data(file, offset, scale, start_x, end_x)
    data_temp = readtable(file);
    
    t = 0:0.004:(size(data_temp.CH1, 1)-1)*0.004;
    t = t';
    
    t = t(1:(end_x - start_x + 1));
    
    data1 = (data_temp.CH1(start_x:end_x) - offset)*scale;
    data2 = (data_temp.CH2(start_x:end_x) - offset)*scale;

end
