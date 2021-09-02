
test_plot('datos.csv');

figure(5);
data_plot('datos.csv', 102, 5/23, 130, 255, 'Polos Complejos Cerca de I');


function test_plot(file)
    data = readtable(file);
    
    plot(data.CH1);
    hold on
    plot(data.CH2);
end

function data_plot(file, offset, scale, start_x, end_x, title_text)
    data = readtable(file);
    
    t = 0:0.004:(size(data.CH1, 1)-1)*0.004;
    t = t';
    
    t = t(1:(end_x - start_x + 1));
    
    plot(t, (data.CH1(start_x:end_x) - offset)*scale);
    hold on
    scatter(t, (data.CH2(start_x:end_x) - offset)*scale);
    grid on
    
    xlabel('Tiempo (s)');
    ylabel('Amplitud (V)');
    title(title_text);

end