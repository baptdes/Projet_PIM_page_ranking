with ada.Text_IO; use ada.Text_IO;
with ada.Float_Text_IO; use ada.Float_Text_IO;
with ada.Integer_Text_IO; use ada.Integer_Text_IO;

with matrice;

procedure test_matrice is
    package Test_Matrice is new Matrice(10);
    use Test_Matrice;

    procedure Afficher(M:in T_mat) is
    begin
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                put (M.Mat(i,j));
            end loop;
            New_Line;
        end loop;
    end Afficher;

    procedure test_initialiser_reussite is
        Matrice_ligne: T_mat;
        Matrice_colonne: T_mat;
        Matrice_Carre: T_mat;
    begin
        -- on initialise une matrice ligne, une matrice colonne, et une matrice carré
        Initialiser(1, 10, 0.0,Matrice_ligne);
        Initialiser(10, 1, 1.0,Matrice_colonne);
        Initialiser(10, 10, 2.0,Matrice_Carre);
    end test_initialiser_reussite;

    procedure test_multiplication is
        M1 : T_mat;
        M2 : T_mat;
    begin
        Initialiser(2, 2, 0.0, M1);
        Initialiser(2, 1, 0.0, M2);

        M1.Mat(1,1) := 1.0;
        M1.Mat(1,2) := 2.0;
        M1.Mat(2,1) := 3.0;
        M1.Mat(2,2) := 4.0;

        M2.Mat(1,1) := 1.0;
        M2.Mat(1,2) := 2.0;
        M2.Mat(2,1) := 3.0;
        M2.Mat(2,2) := 4.0;

        Afficher(Multiplication(M1,M2));
    end test_multiplication;

    procedure test_addition is
        M1: T_mat;
        M2: T_mat;
        M3: T_mat;
    begin
        Initialiser(2, 2, 0.0, M1);
        Initialiser(2, 2, 0.0, M2);

        M1.Mat(1,1) := 1.0;
        M1.Mat(1,2) := 2.0;
        M1.Mat(2,1) := 3.0;
        M1.Mat(2,2) := 4.0;

        M2.Mat(1,1) := 1.0;
        M2.Mat(1,2) := 2.0;
        M2.Mat(2,1) := 3.0;
        M2.Mat(2,2) := 4.0;

        M3 := Addition(M1,M2);
        Afficher(M3);
    end test_addition;

    procedure test_norme is
        M1: T_mat;
    begin
        Initialiser(2, 2, 0.0, M1);

        M1.Mat(1,1) := 1.0;
        M1.Mat(2,1) := 3.0;
        Put(norme(M1));
    end test_norme;

    procedure test_modifier_ligne is
        M1: T_mat;
    begin
        Initialiser(2, 2, 0.0, M1);
        Modifier_ligne(M1,1,3.0);
        Afficher(M1);
    end test_modifier_ligne;

    procedure test_ligne_max is
        M1: T_mat;
    begin
        Initialiser(2, 1, 0.0, M1);
        Modifier_ligne(M1,2,3.0);
        Afficher(M1);
        put(Ligne_max(M1));
    end test_ligne_max;

begin
    test_ligne_max;
    New_Line;
    put("Tout est OK");
end;
