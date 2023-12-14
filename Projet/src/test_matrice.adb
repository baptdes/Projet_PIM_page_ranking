with ada.Text_IO; use ada.Text_IO;
with ada.Integer_Text_IO; use ada.Integer_Text_IO;
with matrice;

procedure test_matrice is
    package Test_Matrice is new matrice(10);
    use Test_Matrice;

    procedure Afficher(M:in T_mat) is
    begin
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                put(M.Mat(i,j));
            end loop;
            New_Line;
        end loop;
    end Afficher;

    procedure test_initialiser_reussite is
    begin
        -- on initialise une matrice ligne, une matrice colonne, et une matrice carré
        Initialiser(1, 10, 0,Matrice_ligne);
        Initialiser(10, 1, 1,Matrice_colonne);
        Initialiser(10, 10, 2,Matrice_Carre);
        Afficher(Matrice_ligne);
        -- On les affiches pour être sur que celles-ci fonctionnent bien
    end test_initialiser_reussite;
begin
    test_initialiser_reussite;
    put("Tout est OK");
end;
