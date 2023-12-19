with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;

package body matrice is
    
    procedure Initialiser(l:in Integer; c:in Integer; x:in Float; M:out T_mat) is
    begin
        for i in 1..l loop
            for j in 1..c loop
                M.Mat(i,j) := x;
            end loop;
        end loop;
        M.nombre_colonne := c;
        M.nombre_ligne := l;
    end Initialiser;
    
    
    --function Ligne_Vide (M :in T_mat; l:in Integer) is
    --begin
    --    none;
    --end Ligne_vide;
    
    
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float) is
    begin
        if ligne > 0 and ligne < M.nombre_ligne and colonne > 0 and colonne < M.nombre_colonne then
            M.Mat(ligne,colonne) := valeur;
        else
            raise Case_Hors_Bornes;
        end if;
    end Enregistrer;    
    
    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float) is
    begin
        if ligne > 0 and ligne <= M.nombre_ligne then
            for i in 1..M.nombre_colonne loop
                M.Mat(ligne,i) := valeur;
            end loop;
        else
            raise Ligne_Hors_Bornes;
        end if;                
    end Modifier_ligne;

    function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean is
        res : Boolean;
    begin 
        res := True;
        for j in 1..M.nombre_colonne loop
            if abs(M.Mat(l,j)) > 0.00001 then
                res := False;
            else
                Null;
            end if;
        end loop;
        return res;
    end Ligne_Vide;
    
    
    function Ligne_max(M:in T_mat) return integer is
        maximum: Float;
        indice : integer;
    begin
        if M.nombre_colonne = 1 then
            maximum := 0.0;
            indice := 0;
            for i in 1..M.nombre_ligne loop
                if M.Mat(i,1) >= maximum then
                    maximum := M.Mat(i,1);
                    indice := i;
                else
                    Null;
                end if;
            end loop;
            return indice;
        else
            raise Maximum_Indeterminable;
        end if;
    end Ligne_max;    
    
    
    function "+" (M1,M2 : in T_mat) return T_mat is
        Somme: T_mat;
    begin
        
        if M1.nombre_colonne = M2.nombre_colonne and M1.nombre_ligne = M2.nombre_ligne then
            Somme.nombre_colonne := M1.nombre_colonne;
            Somme.nombre_ligne := M2.nombre_ligne;
            for i in 1..M1.nombre_ligne loop
                for j in 1..M2.nombre_colonne loop
                    Somme.Mat(i,j) := M1.Mat(i,j) + M2.Mat(i,j);
                end loop;
            end loop;
            return Somme;
        else
            raise Taille_Differente_Addition;
        end if;   
    end "+";
    
    
    function "*" (M1,M2:in T_mat) return T_mat is
        Produit: T_mat;
        s: Float;
    begin
        if M1.nombre_colonne = M2.nombre_ligne then
            Produit.nombre_ligne := M1.nombre_ligne;
            Produit.nombre_colonne := M2.nombre_colonne;
            for i in 1..Produit.nombre_ligne loop
                for j in 1..Produit.nombre_colonne loop
                    s := 0.0;
                    for k in 1..M1.nombre_colonne loop
                        s := s + M1.Mat(i,k)*M2.Mat(k,j);
                    end loop;
                    Produit.Mat(i,j) := s;
                end loop;
            end loop;
            return Produit;
        else
            raise Taille_Incompatible_Multiplication;
        end if;                        
    end "*";
    
    
    function Transpose(M:in T_mat) return T_mat is
        T : T_mat;
    begin
        T.nombre_colonne := M.nombre_ligne;
        T.nombre_ligne := M.nombre_colonne;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                T.Mat(j,i) := M.Mat(i,j);
            end loop;
        end loop;
        return T;
    end Transpose;
    
    function "*" (lambda:in Float ; M:in T_mat) return T_mat is
        T : T_mat;
    begin
        T.nombre_colonne := M.nombre_colonne;
        T.nombre_ligne := M.nombre_ligne;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                T.Mat(i,j) := lambda * M.mat(i,j);
            end loop;
        end loop;
        return T;
    end "*";

    function norme (M:in T_mat) return Float is
        s : Float;
    begin
        s := 0.0;
        for i in 1..M.nombre_colonne loop
            s := s + M.Mat(1,i)*M.Mat(1,i);
        end loop;
        return sqrt(s);
    end norme;

    procedure Afficher (M : in T_mat) is
    begin
        New_Line;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                Put (M.Mat(i, j), 6, 2);
                Put(" ");
            end loop;
            New_Line;
        end loop;
    end Afficher;

end matrice;
