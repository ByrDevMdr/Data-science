clc;
clear;
close all;

% Entradas
% Pedir la funcion al usuario
textoFuncion=input('Ingrese la funcion f(x): ', 's');

% Convertir el texto introducido en una funcion de MATLAB
f=str2func(textoFuncion);

% Punto inicial
x0=input('Ingrese el punto inicial x0 como vector: ');
% Tasa de aprendizaje
alpha=input('Ingrese la tasa de aprendizaje alpha: ');
% Maximo de iteraciones
N=input('Ingrese el maximo de iteraciones N: ');
% Tolerancia
epsilon=input('Ingrese el criterio de paro epsilon: ');
% Parámetros para el gradiente numérico
% Tamano del paso utilizado para calcular la derivada
h=1e-6;

% Numero de variables
n=length(x0);

% Historial
% Crear una matriz para guardar las iteraciones
% Columnas:
% 1 = k
% 2 hasta n+1 = xk
% n+2 = f(xk)
% n+3 = ||gk||
historial = zeros(N+1,n+3);
% Inicializar resultados
x=x0(:);
% Variable para indicar por que termino el algoritmo
motivo='Se alcanzo el maximo de iteraciones';

%% DESCENSO POR GRADIENTE

for k=0:N-1
    % Calcular el gradiente en xk
    g = gradienteNumericoN(f, x, h);
    % Guardar los datos de la iteracion
    historial(k + 1, 1)=k;
    historial(k + 1, 2:n+1)=x';
    historial(k + 1, n+2)=f(x);
    historial(k + 1, n+3)=norm(g);

    % Actualizar x usando descenso por gradiente
    xNuevo=x-alpha*g;
    % Criterio de paro 1:
    % magnitud del gradiente suficientemente pequena
    if norm(g) <= epsilon
        motivo = 'Se cumplio ||gradiente|| <= epsilon';
        x = xNuevo;
        break;
    end

    % Criterio de paro 2:
    % el cambio en x es suficientemente pequeno
    if norm(xNuevo - x) <= epsilon
        motivo='Se cumplio ||x(k+1)-x(k)|| <= epsilon';
        x=xNuevo;
        break;
    end

    % Actualizar x
    x=xNuevo;
end
% Mostrar filas o usadas.
historial=historial(1:k+1,:);
% Mostrar resultados.
fprintf('Solucion encontrada:\n');
for i=1:n
    fprintf('x%d = %.8f\n', i, x(i));
end
fprintf('Valor de la funcion: f(x) = %.8f\n', f(x));
fprintf('Iteraciones realizadas: %d\n', k);
fprintf('Motivo de paro: %s\n', motivo);
% Mostrar historial final.
fprintf('%5s ', 'k');
for i=1:n
    fprintf('%15s ', sprintf('x%d',i));
end
fprintf('%15s %15s\n', 'f(xk)', '||gk||');

for i = 1:size(historial, 1)
    fprintf('%5d ', historial(i,1));
    for j=1:n
        fprintf('%15.8f ', historial(i,j+1));
    end
    fprintf('%15.8f %15.8f\n', ...
        historial(i,n+2), ...
        historial(i,n+3));
end

%% Graficar
% Obtener los valores de x que fueron visitados
valoresX = historial(:,2:n+1);

% Encontrar el valor minimo y maximo de x
xmin = min(valoresX(:));
xmax = max(valoresX(:));

% Agregar un margen a la grafica
margen = 0.2 * (xmax - xmin);

% Crear el intervalo de x para dibujar la funcion
xGrafica = linspace(xmin - margen, xmax + margen, 500);

% Evaluar la funcion en cada punto
% La grafica se realiza para el caso de 1 variable
if n==1
    yGrafica = f(xGrafica);
    % Crear una nueva ventana de grafica
    figure;
    % Dibujar la funcion
    plot(xGrafica, yGrafica, 'LineWidth', 2);
    % Mantener la grafica para agregar los puntos
    hold on;
    % Dibujar los puntos visitados por el algoritmo
    plot(valoresX, historial(:,n+2), 'o-', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 6);
    % Marcar el punto inicial
    plot(valoresX(1), historial(1,n+2), 's', ...
        'MarkerSize', 9);
    % Marcar el punto final
    plot(valoresX(end), historial(end,n+2), '*', ...
        'MarkerSize', 12);
    % Nombre de los ejes
    xlabel('x');
    ylabel('f(x)');
    % Titulo de la grafica
    title('Descenso por gradiente');
    % Mostrar una cuadricula
    grid on;
    % Agregar una leyenda
    legend('f(x)', 'Iteraciones', ...
        'Punto inicial', 'Solucion final', ...
        'Location', 'best');
    % Terminar la superposicion de graficas
    hold off;
end