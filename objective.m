function [f, gradf] = objective(x)
x = x(:);

f = sum(x);

if nargout > 1
    gradf = ones(size(x));
end

end