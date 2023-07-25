[heart_scale_label, heart_scale_inst] = libsvmread('../heart_scale');
model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07');
[predict_label, accuracy, dec_values] = svmpredict(heart_scale_label, heart_scale_inst, model); % test the training data



alpha = zeros(size(heart_scale_label,1),1);
alpha_reduced=[model.sv_coef(1:model.nSV(1))/model.Label(1);model.sv_coef(model.nSV(1)+1:end)/model.Label(2)];
for ii=1:model.totalSV
    alpha(model.sv_indices(ii))=alpha_reduced(ii);
end



w = model.SVs' * model.sv_coef;
b = -model.rho;


model = svmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07 -b 1');
[heart_scale_label, heart_scale_inst] = libsvmread('../heart_scale');
[predict_label, accuracy, prob_estimates] = svmpredict(heart_scale_label, heart_scale_inst, model, '-b 1');

