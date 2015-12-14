% CODE DECODER

% Ouvrir l'image du qrcode dans une matrice

qrcode = imread('dirty.jpg');

% Mise à niveau des blancs et noirs
% Fonction MatLab qui prend une image en niveau de gris et applique un niveau de treshold pour retourner une image en noir et blanc, la matrice retournée est une matrice LOGIQUE*

qr = im2bw(qrcode, 0.5)

* Lissage via un filtre médian (plus adapté que le linéaire pour le bruit impulsionnel)

clean = medfilt2(qr);



% Créer un vecteur de resize pour notre qrcode

vector = [21 21];

% Resize la capture selon le vecteur

final = imresize(clean, vector);


% Visualiser

imshow(final, 'InitialMagnification','fit');
