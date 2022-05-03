clc;
close all;

x = [];t = [];test_x = []; test_t = []; all_x = [];
% stop_window();
for i=4:6
    name = sprintf('%.0d.txt', i);
    [input_big,...
    input_small, ...
    output_big, ...
    output_small, ...
    angle] = data_extract(name, 0.5, 1);
    
    x = [x; input_big(1:1:length(input_big), :)];
    t = [t; output_big(1:1:length(output_big), :)];
    
    test_x = [test_x; input_small(1:1:length(input_small), :)];
    test_t = [test_t; output_small(1:1:length(output_small), :)];
    all_x = [all_x; input_big; input_small];
end
%% 
% f1 = figure(1);
% set(f1, 'position', [500 700 1200 800])
% subplot(2, 1, 1);
% hold on;
% plot(smoothdata(all_x, 'loess', 30));
% % bias = [354   405   464];
bias = x(1, :);
% plot([1, length(all_x)], [ bias(1, 1) bias(1, 1)]);
% plot([1, length(all_x)], [ bias(1, 2) bias(1, 2)]);
% plot([1, length(all_x)], [ bias(1, 3) bias(1, 3)]);
% % plot([1, length(all_x)], [ bias(1, 4) bias(1, 4)]);
% % plot([1, length(all_x)], [ bias(1, 5) bias(1, 5)]);
% % plot([1, length(all_x)], [ bias(1, 6) bias(1, 6)]);
% % plot([1, length(all_x)], [ bias(1, 7) bias(1, 7)]);
% % plot([1, length(all_x)], [ bias(1, 8) bias(1, 8)]);
% 
% subplot(2, 1, 2);
% hold on
% plot(smoothdata(test_x, 'loess', 30) - bias);

test_x = (test_x - bias);
x = (x - bias);
%% 
perf_best = 100;
x_filter = smoothdata(x, 'loess', 30);
test_x_filter = smoothdata(test_x, 'loess', 30);

layer_fine = [ 8, 8, 8, 8, 8 ];
layer_test = [ 1, 1 ] * 4;
flag = 1;
i = 0;
while (perf_best > 4) && flag
    net = feedforwardnet(layer_test, 'trainlm');
    net = train(net, x_filter', t');
    % 循环测试用
    y = net(x_filter');
    if i > 20
        flag = 0;
    end
    i = i+1;
    shown = y';

    test_y = net(test_x_filter');
    shown_test = test_y';

    perf = perform(net, y, t');
    perf_test = perform(net,test_y, test_t');
    fprintf('origin:%.3f test:%.3f\r', perf, perf_test);
    %%    
    if (perf_test < perf_best) && (perf_test < 13)
        save net_test.mat net
        perf_best = perf_test;
        fprintf('Get one good net \r');
        net_best = net;
        row = 7;
        col = 1;
        %% 
        
        best = figure(101);

        set(best, 'position', [50 50 1200 1200])
        subplot(row, col, 1);
        hold off;
        title('Original Normalized Input');
        hold on
        plot(x_filter);
        legend('Channel 1','Channel 2','Channel 3');
       
        subplot(row, col, 2);
        hold off
        title('Force Sensor Value')
        hold on
        plot(t);
        legend('Fx','Fy','Fz');
        hold off

        subplot(row, col, 3);
        hold off
        title('Estimation Value by Orginal Data');
        hold on
        plot(shown);
        legend('Fx','Fy','Fz');

        subplot(row, col, 4);
        hold off
        title('Origin Test Data');
        hold on
        plot(test_x_filter);
        legend('Channel 1','Channel 2','Channel 3');

        subplot(row, col, 5);
        hold off
        title('Test Data Force Sensor Value');
        hold on
        plot(test_t);
        legend('Fx','Fy','Fz');

        subplot(row, col, 6);
        hold off
        title('Estimation Value by Test Data');
        hold on
        plot(shown_test);
        legend('Fx','Fy','Fz');

        subplot(row, col, 7);
        hold off
        title('Estimation Value Error by Test Data');
        hold on
        plot(test_t - shown_test);
        legend('Fx','Fy','Fz');
    end
    %% 
    f = figure(50);
    set(f, 'position', [50 50 1200 1200])
%     subplot(row, col, 1);
%     hold off;
%     title('original normalized input');
%     plot(x_filter);
%     hold on
% 
%     subplot(row, col, 2);
%     hold off
%     title('force sensor value')
%     plot(t);
%     hold on
% 
%     subplot(row, col, 3);
%     hold off
%     title('estimation value by orginal data');
%     plot(shown);
%     hold on

    subplot(row, col, 1);
    hold off
    title('origin test data');
    plot(test_x_filter);
    hold on

    subplot(row, col, 2);
    hold off
    title('test data force sensor value');
    plot(test_t);
    hold on

    subplot(row, col, 3);
    hold off
    title('estimation value by test data filtered');
    plot(shown_test);
    hold on

    subplot(row, col, 4);
    hold off
    title('estimation value error by test data filtered');
    plot(test_t - shown_test);
    hold on
end
%
%% 
% y = net(x_filter');
% shown = y';
% 
% test_y = net(test_x_filter');
% shown_test = test_y';
% 
% perf = perform(net,y, t');
% perf_test = perform(net,test_y, test_t');
% fprintf('origin:%.3f test:%.3f\r', perf, perf_test);
% 
% figure(2);
row = 7;
col = 1;
% subplot(row, col, 1);
% hold on
% title('original normalized input');
% plot(x);
% 
% subplot(row, col, 2);
% hold on
% title('force sensor value')
% plot(t);
% 
% subplot(row, col, 3);
% hold on
% title('estimation value by orginal data');
% plot(shown);
% 
% subplot(row, col, 4);
% hold on
% title('origin test data');
% plot(test_x)
% 
% subplot(row, col, 5);
% hold on
% title('test data force sensor value');
% plot(test_t);
% 
% subplot(row, col, 6);
% hold on
% title('estimation value by test data');
% plot(shown_test);
% 
% subplot(row, col, 7);
% hold on
% title('estimation value error by test data filtered');
% plot(test_t - shown_test);
%% 
row = 4;
y = net_best(x_filter');
shown = y';

test_y = net_best(test_x_filter');
shown_test = test_y';

perf = perform(net_best, y, t');
perf_test = perform(net_best,test_y, test_t');
fprintf('origin:%.3f test:%.3f\r', perf, perf_test);
%% 
% test = figure(100);
% set(test, 'position', [500 50 1200 1200])
% subplot(row, col, 1);
% hold on
% title('original normalized input');
% plot(x_filter);
% 
% subplot(row, col, 2);
% hold on
% title('force sensor value')
% plot(t);
% plot(angle);
% 
% subplot(row, col, 3);
% hold on
% title('estimation value by orginal data');
% plot(shown);
% 
% subplot(row, col, 1);
% hold on
% title('Orignal Hall Data');
% plot(test_x_filter)
% legend('Axis_1','Axis_2','Axis_3','Tan_3','Axis_4','Tan_4')
% 
% subplot(row, col, 2);
% hold on
% title('Force Sensor Value');
% plot(test_t);
% legend('Fx','Fy','Fz','Mx','My','Mz')
% 
% subplot(row, col, 3);
% hold on
% title('Estimation Data by Prediction');
% plot(shown_test);
% legend('Fx','Fy','Fz','Mx','My','Mz')
%                                                                                                                                                 
% subplot(row, col, 4);
% hold on
% title('Estimation Error');
% plot(test_t - shown_test);
% legend('Fx','Fy','Fz','Mx','My','Mz')
%% 

function stop_window()
    operator = uifigure('Position',[2000 600 200 40]); 
    stop_btn = uibutton(operator,...
          'Position',[5 5 140 20],...
          'ButtonPushedFcn', @(stop_btn,event) stop(stop_btn)); 
end
function stop()
    flag = 0;
    fprintf('stop\r');
end