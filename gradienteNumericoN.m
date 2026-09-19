function g=gradienteNumericoN(f,x,h)
% Calcular la derivada mediante diferencias centrales
    g=zeros(size(x));
    for i=1:length(x)
        xMas=x;
        xMenos=x;
        xMas(i)=xMas(i)+h;
        xMenos(i)=xMenos(i)-h;
        g(i)=(f(xMas)-f(xMenos))/(2*h);
    end
end