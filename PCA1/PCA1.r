PCA = function(table, norm = T, order = 2, desiredvariance = 0.8) {
    check = apply(table, 2, is.numeric)  #We check if we have only quantitative values
    if (mean(check) == 1) {
        table = scale(table, center = TRUE, scale = norm)  #We center the dataset (but we don't scale)
        n = dim(table)[1]  #number of indivuals (rows)
        p = dim(table)[2]  #number of variables (columns)
        D = 1/n * diag(rep(1, n))  #matrix with the weights of indivuals
        Q = diag(rep(1, p))
        S = t(table) %*% D %*% table  #sample covariance matrix
        u = diag(S)
        u = 1/sqrt(u)
        D1s = diag(u)
        R = D1s %*% S %*% D1s  #sample correlation matrix
        eigenvalues = eigen(S)$values
        eigenvectors = eigen(S)$vectors
        inertia = sum(diag(S))  #inertia is the sum of the eigenvalues
        cum = cumsum(eigen(S)$values)/inertia  # cumulative energy /inertia
        i = 1
        while (cum[i] < desiredvariance) {
            i = i + 1
        }
        i = min(order, i)
        # We project the table on the i first vectors We compute the main factors and the coordinates of the individuals on the i first axes Main
        # factors are main axes since Q=Ip Gk for 1<=k<=i fulfill : Fk=table*uk where (uk)_k are the main axes
        FF = matrix(rep(0, n * i), ncol = i)  #zero matrix for storing the Fk's
        G = matrix(rep(0, p * i), ncol = i)  #zero matrix for storing the Gk's
        nor = matrix(rep(0, p * i), ncol = i)
        cor = matrix(rep(0, i * p), ncol = p)
        for (k in 0:i) {
            FF[, k] = table %*% eigenvectors[, k]
            G[, k] = sqrt(eigenvalues[k]) * eigenvectors[, k]
        }
        for (m in 1:i) {
            for (j in 1:p) {
                cor[m, j] = G[j, m]/sqrt(1/n * t(table[, j]) %*% table[, j])
            }
        }
        return(list(FF = FF, G = G, cor = cor, cum = cum, R = R))  #We return FF,G,cor,the inertia proportion and the correlation matrix
        # Coordinates of points in the area of variables
    } else {
        stop("The argument table must be a matrix/dataframe of exclusive quantitative values")
    }
}
