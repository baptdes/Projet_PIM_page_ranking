-- Définition de structures de données associatives sous forme d'une liste
-- chaînée associative (LCA).
with LCA;

generic
    type T_Cle is private;
    Capacite : Integer;
    type T_Valeur is private;
    with function fonction_hachage (taille: in Integer; cle_1: in T_Cle; cle_2: in T_Cle) return Integer;


package TH is

    type T_TH is limited private;

    type T_Couple is record
        Cle_1 : T_Cle;
        Cle_2 : T_Cle;
    end record;

    package LCA_TH is
        new LCA (T_Cle => T_Couple, T_Valeur => T_Valeur);
    use LCA_TH;

    -- Permet de définir objet Couple grâce à deux clé
    procedure Couplage(Couple: out T_Couple; Cle1 : in T_Cle ; Cle2 : in T_Cle);

    -- Initialiser un TH. Le TH est vide.
	procedure Initialiser(TH: out T_TH) with
            Post => Est_Vide (TH);


    -- Détruire un TH. Il ne devra plus être utilisée.
	procedure Detruire (TH : in out T_TH);


	-- Est-ce qu'un TH est vide ?
	function Est_Vide (TH : T_TH) return Boolean;


	-- Obtenir le nombre de cases d'un TH.
	function Taille (TH: in T_TH) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (TH);


	-- Enregistrer une valeur associée à une Clé dans une Sda.
	-- Si la clé est déjà présente dans la Sda, sa valeur est changée.
	procedure Enregistrer (TH : in out T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle ; Valeur : in T_Valeur) with
		Post => Cle_Presente (TH, Cle1, Cle2) and (La_Valeur(TH, Cle1, Cle2) = Valeur)   -- valeur insérée
				and (not (Cle_Presente (TH, Cle1, Cle2)'Old) or Taille (TH) = Taille (TH)'Old)
				and (Cle_Presente (TH, Cle1, Cle2)'Old or Taille (TH) = Taille (TH)'Old + 1);

	-- Supprimer la valeur associée à une Clé dans un TH
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans le TH
	procedure Supprimer (TH : in out T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle ) with
		Post =>  Taille (TH) = Taille (TH)'Old - 1 -- un élément de moins
			and not Cle_Presente (TH, Cle1, Cle2);         -- la clé a été supprimée


	-- Savoir si une Clé est présente dans une Sda.
	function Cle_Presente (TH : in T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle ) return Boolean;


	-- Obtenir la valeur associée à une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans l'Sda
	function La_Valeur (TH : in T_TH ; Cle1 : in T_Cle ; Cle2 : in T_Cle ) return T_Valeur;


	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traitement (Couple : T_Couple; Valeur: in T_Valeur);
	procedure Pour_Chaque (TH : in T_TH);


	-- Afficher un TH en révélant sa structure interne.
	-- Voici un exemple d'affichage :
    --
    -- LCA numéro X
    -- ["clé":valeur] --> ["clé": valeur] --> ...

	generic
		with procedure afficher_cle (Cle : T_Couple);
		with procedure afficher_donnee (Valeur : in T_Valeur);
	procedure Afficher_Debug (TH : in T_TH);


private
    type T_TH is array (1..Capacite) of T_LCA;

end TH;
