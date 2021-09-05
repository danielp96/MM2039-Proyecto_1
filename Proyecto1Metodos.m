%% Universidad del Valle de Guatemala
%  Depto de Matematica
%  Métodos Numéricos 1, sección 30
%  Proyecto 1
%  Santiago Fernandez 18171
%  Camila Lemus 18272
%  Diego Mencos 18300
%  Larry Paul 18117
%  Daniel Barrientos 18***

close all
%% Extrayendo Datos del Excel
A = 4;
k = -0.5;
x = linspace(0,10,1000);
f = 5.5;
y = A*exp(k*x).*sin(2*pi*f*x);

%% Separando datos maximos
y_ant = 0
Ymax = [];
Xmax = [];
C = 1;
for n=1:size(x,2)
    switch C
        case 1
            if y_ant>y(n)
                Ymax = [Ymax y_ant];
                Xmax = [Xmax x(n-1)];
                C = 2;
            end
        case 2
            if y_ant<y(n)
                Ymax = [Ymax y_ant];
                Xmax = [Xmax x(n-1)];
                C = 1;
            end
    end
    y_ant = y(n);
end

scatter(Xmax,Ymax,1,'r')
hold off

%% Obteniendo frecuencia
T_reg = 2*((max(Xmax)-min(Xmax))/(size(Xmax,2)-1));
f_reg = 1/T_reg

%% Linealizando el exponencial
Ymax = abs(Ymax);
Ylineal = log(Ymax);
MA = [size(Xmax,2) sum(Xmax); sum(Xmax) sum(Xmax.^2)];
MB = [sum(Ylineal);sum(Ylineal.*Xmax)];

Sol = inv(MA)*MB;

A_reg = exp(Sol(1));
k_reg = Sol(2);

y_reg = A_reg*exp(k_reg*x).*sin(2*pi*f_reg*x);

%% Graficando original y regresion
figure(3)
plot(x,y,'r')
hold on
plot(x,y_reg,'b')
hold off
%% Tomando puntos máximos

