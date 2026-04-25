data = load('MNIST.mat');

N = 784;
target = 9;
n_epochs = 200;

y_train = binarize_labels(data.train.labels, target);
y_test  = binarize_labels(data.test.labels , target);

J = zeros(N,1);



% masks for true positive patterns
train_mask = y_train == 1;
test_mask  = y_test == 1;

train_acc = zeros(1, n_epochs);
test_acc  = zeros(1, n_epochs);

for epoch = 1:n_epochs
    % loop over the train dataset
    for mu = 1:length(data.train.images)
        % get this image and label
        x_mu = data.train.images(:, mu);
        y_mu = y_train(mu);

        
        activation = sign(J' * x_mu);
        if activation ~= y_mu
            J = J + y_mu * x_mu; % Update weights
        end
    end
    
    % train accuracy
    train_preds = sign(J' * data.train.images);
    tp_train = mean(train_preds(y_train == 1)  == y_train(y_train == 1)');
    tn_train = mean(train_preds(y_train == -1) == y_train(y_train == -1)');
    train_acc(epoch) = (tp_train + tn_train) / 2;

    % test accuracy
    test_preds = sign(J' * data.test.images);
    tp_test = mean(test_preds(y_test == 1)  == y_test(y_test == 1)');
    tn_test = mean(test_preds(y_test == -1) == y_test(y_test == -1)');
    test_acc(epoch) = (tp_test + tn_test) / 2;

    fprintf('Epoch %d — Train: %.2f%%  Test: %.2f%%\n', ...
        epoch, train_acc(epoch)*100, test_acc(epoch)*100);
    
end

figure;
plot(1:n_epochs, train_acc * 100, 'b-o', 'DisplayName', 'Train');
hold on;
plot(1:n_epochs, test_acc * 100, 'r-o', 'DisplayName', 'Test');
xlabel('Epoch');
ylabel('Accuracy (%)');
title(sprintf('Accuracy for digit %d vs all', target));
legend('Location', 'southeast');
grid on;