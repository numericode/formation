<?php

namespace AppBundle\Controller;

use AppBundle\Forms\PersonnageType;
use AppBundle\Forms\PersonnageSearchType;
use AppBundle\Models\Personnage;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class PersonnagesController extends Controller {
	/**
	 * @Route("/personnage/all/", name="personnagesList")
	 */
	public function allAction(Request $request) {
		// $man = new PersonnageManager ( $this->get ( 'database_connection' ) );
		$man = $this->get ( 'persomanager' );
		$all = $man->getAll ();
		
		// $listcontent = '<ul>';
		// foreach ( $all as $personnage ) {
		// $idPerso = $personnage->getId ();
		// $nomPerso = $personnage->getNom ();
		// $localisationPerso = $personnage->getLocalisation ();
		// $forcePerso = $personnage->getForcePerso ();
		// $degatsPerso = $personnage->getDegats ();
		// $niveauPerso = $personnage->getNiveau ();
		// $experiencePerso = $personnage->getExperience ();
		
		// $listcontent = $listcontent . '<li>' . $idPerso . ' - ' . $nomPerso . ' [' . $localisationPerso . '] ' . '(N:' . $niveauPerso . ', E:' . $experiencePerso . ', F:' . $forcePerso . ', D:' . $degatsPerso . ')</li>';
		// }
		// $listcontent = $listcontent . '</ul>';
		// return new Response ( '<html><body>Liste des personnages :' . $listcontent . ' </body></html>' );
		return $this->render ( 'personnage/all.html.twig', [ 
				'liste_personnages' => $all 
		] );
	}
	/**
	 * @Route("/personnage/new/", name="newPersonnage")
	 */
	public function newAction(Request $request) {
		$p = new Personnage ();
		$form = $this->createForm ( PersonnageType::class, $p );
		$form->handleRequest ( $request );
		if ($form->isValid ()) {
			$p = $form->getData ();
			// $p->setNiveau ( $request->request->get ( 'personnage' ) ['niveau'] );
			// $p->setExperience ( $request->request->get ( 'personnage' ) ['experience'] );
			// $p->setForcePerso ( $request->request->get ( 'personnage' ) ['forceperso'] );
			// $p->setDegats ( $request->request->get ( 'personnage' ) ['degats'] );
			// $p->setNom ( $request->request->get ( 'personnage' ) ['nom'] );
			// $p->setLocalisation ( $request->request->get ( 'personnage' ) ['localisation'] );
			$man = $this->get ( 'persomanager' );
			$man->addPersonnage ( $p );
			return $this->redirectToRoute ( 'personnageDetail', array (
					'nom' => $p->getNom () 
			) );
		} else
			
			return $this->render ( 'personnage/form.html.twig', array (
					'form' => $form->createView (),
					'title' => 'Création de personnage' 
			) );
	}
	/**
	 * @Route("/personnage/search/", name="searchPersonnage")
	 */
	public function searchAction(Request $request) {
		$p = new Personnage ();
		$form = $this->createForm ( PersonnageSearchType::class, $p );
		$form->handleRequest ( $request );
		if ($form->isValid ()) {
			return $this->redirect ( $this->generateUrl ( 'personnageDetail', array (
					// 'nom' => $request->request->get ( 'personnage_search' ) ['nom']
					'nom' => $form->getData ()->getNom () 
			) ) );
		} else
			return $this->render ( 'personnage/form.html.twig', array (
					'form' => $form->createView (),
					'title' => 'Recherche de personnage' 
			) );
	}
	/**
	 * @Route("/personnage/{nom}/", name="personnageDetail")
	 */
	public function getAction(Request $request) {
		// print_r ( $request );
		$nom = $request->get ( 'nom' );
		$man = $this->get ( 'persomanager' );
		return $this->render ( 'personnage/detail.html.twig', [ 
				'personnage' => $man->getPersonnageByNom ( $nom ) 
		] );
	}
	/**
	 * @Route("/personnage/delete/{id}/", name="deletePersonnage", requirements={"id"="\d+"})
	 */
	public function deleteAction(Request $request) {
		$id = $request->get ( 'id' );
		
		return new Response ( '<html><body>Suppression du personnage : ' . $id . '</body></html>' );
	}
	/**
	 * @Route("/personnage/edit/{nom}/", name="editPersonnage")
	 */
	public function editAction(Request $request) {
		$nom = $request->get ( 'nom' );
		$man = $this->get ( 'persomanager' );
		$p = $man->getPersonnageByNom ( $nom );
		$form = $this->createForm ( PersonnageType::class, $p );
		$form->handleRequest ( $request );
		if ($form->isValid ()) {
			$man->modifyPersonnageById ( $form->getData () );
			return $this->render ( 'personnage/detail.html.twig', [ 
					'personnage' => $form->getData () 
			] );
		} else {
			return $this->render ( 'personnage/form.html.twig', array (
					'form' => $form->createView (),
					'title' => 'Modification du personnage' 
			) );
		}
	}
}
