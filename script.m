
%test_plot('./data.csv');

[t, data1, data2] = filter_data('./data.csv', 102, 5/23, 130, 255);

data1 = data1 -5;
data2 = data2 -5;

figure(3);
plot(t, data1);
hold on

plot(t, data2);
plot(t, abs(data2), '-x');




function test_plot(file)
    data = readtable(file);
    
    plot(data.CH1);
    hold on
    plot(data.CH2);
end

function [t, data1, data2] = filter_data(file, offset, scale, start_x, end_x)
    data_temp = readtable(file);
    
    t = 0:0.004:(size(data_temp.CH1, 1)-1)*0.004;
    t = t';
    
    t = t(1:(end_x - start_x + 1));
    
    data1 = (data_temp.CH1(start_x:end_x) - offset)*scale;
    data2 = (data_temp.CH2(start_x:end_x) - offset)*scale;

end