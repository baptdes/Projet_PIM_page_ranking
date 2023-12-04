with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


    procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := null;
	end Initialiser;


    procedure Detruire (Sda : in out T_LCA) is
        Tempo: T_LCA;
    begin
        if Sda = null then
            null;
        else
            Tempo := Sda.all.Suivant;
            Free (Sda);
            Detruire (Tempo);
        end if;
	end Detruire;


    procedure Afficher_Debug (Sda : in T_LCA) is
        tempo: T_LCA;
    begin
        tempo := Sda;
        while tempo /= null loop
            put("[");
            Afficher_Cle (tempo.all.Cle);
            put (":");
            Afficher_Donnee (tempo.all.Valeur);
            put("]");
            put("-->");
            tempo := tempo.all.Suivant;
        end loop;
	end Afficher_Debug;


	function Est_Vide (Sda : T_LCA) return Boolean is
    begin
        return Sda = null;
	end Est_Vide;


    function Taille (Sda : in T_LCA) return Integer is
        taille: integer ;
        tempo: T_LCA;
    begin
        tempo := Sda;
        taille := 0;
        while not(Est_Vide(tempo)) loop
            tempo := tempo.all.Suivant;
            taille := taille+1;
        end loop;
		return taille;
	end Taille;


    procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Valeur : in T_Valeur) is
        Pointeur_New_Cellule: T_LCA;
    begin
        if Sda = null then
            -- on crée une cellule a placer en fin de chaine
            Pointeur_New_Cellule := new T_Cellule;
            Pointeur_New_Cellule.all.Cle := Cle;
            Pointeur_New_Cellule.all.Valeur := Valeur;
            Pointeur_New_Cellule.all.Suivant := null;
            Sda := Pointeur_New_Cellule;
            -- on libére le mémoire
            Pointeur_New_Cellule := null;
        elsif Sda.all.Cle = cle then
            -- si la clé existe déjà, on modifie la valeur
            Sda.all.Valeur := Valeur;
        else
            -- sinon, on explore la Sda plus loin
            Enregistrer(Sda.all.Suivant,Cle,Valeur);
        end if;

	end Enregistrer;


    function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
    begin
        if Sda = null then
            return False;
        elsif Sda.all.Cle = Cle then
            return True;
        else
            return Cle_Presente(Sda.all.Suivant, Cle);
        end if;
    end Cle_Presente;

    function La_Valeur (Sda : in T_LCA ; Cle : in T_Cle) return T_Valeur is
	begin
        if Sda = null then
            raise Cle_Absente_Exception;
        elsif Sda.all.Cle = Cle then
            return Sda.all.Valeur;
        else
            return La_Valeur (Sda.all.Suivant, Cle);
        end if;
	end La_Valeur;


    procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
        Tempo: T_LCA;
    begin
        if Sda = null then
            raise Cle_Absente_Exception;
        elsif Sda.all.Cle = Cle then
            Tempo := Sda;
            Sda := Sda.all.Suivant;
            Free (Tempo);
        else
            Supprimer(Sda.all.Suivant, Cle);
        end if;
	end Supprimer;


	procedure Pour_Chaque (Sda : in T_LCA) is
    begin
        if Sda = null then
            null;
        else
            begin
                Traiter (Sda.all.Cle,Sda.all.Valeur);
            exception
                when others =>
                    null;
            end;
            Pour_Chaque(Sda.all.Suivant);
        end if;
	end Pour_Chaque;


end LCA;
