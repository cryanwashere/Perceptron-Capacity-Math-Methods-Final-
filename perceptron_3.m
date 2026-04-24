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

true_positive_train_acc = zeros(1, n_epochs);
true_positive_test_acc  = zeros(1, n_epochs);

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
    
    % compute true positive accuracy on train
    train_preds = sign(J' * data.train.images(:, train_mask));
    true_positive_train_acc(epoch) = mean(train_preds == y_train(train_mask)');

    % compute true positive accuracy on test
    test_preds = sign(J' * data.test.images(:, test_mask));
    true_positive_test_acc(epoch) = mean(test_preds == y_test(test_mask)');

    fprintf('Epoch %d — Train TP: %.2f%%  Test TP: %.2f%%\n', ...
        epoch, true_positive_train_acc(epoch)*100, true_positive_test_acc(epoch)*100);
    
end

figure;
plot(1:n_epochs, true_positive_train_acc * 100, 'b-o', 'DisplayName', 'Train TP');
hold on;
plot(1:n_epochs, true_positive_test_acc * 100, 'r-o', 'DisplayName', 'Test TP');
xlabel('Epoch');
ylabel('True Positive Accuracy (%)');
title(sprintf('True positive accuracy for digit %d vs all', target));
legend('Location', 'southeast');
grid on;