class BallManager{
  
  int nbBalls;
  int nbMaxDelais;
  float [][] phases;    // phase  à suivre le numero de la balle et le temps de decalage du suivi

  BallManager(int nbBalls, int nbMaxDelais)
  {
    this.nbBalls = nbBalls;
    this.nbMaxDelais = nbMaxDelais;
    this.phases = new float[nbBalls][nbMaxDelais];

    /*
      Initialisation des boules 
      la première boule à une phase
       une phase c'est un endroit sur le cercle en radiant
      les boules qui suivent leur phase est composé d'un temps et d'un espace/écart  
    */
    for (int i = 0; i < this.nbBalls; i++) {
    for (int j = 0; j < this.nbMaxDelais; j++)
      phases[i][j] = PI; // on met un écart de 0 ou PI (c'est la même chose)
    }
  }


  void updateAndDraw(float lastBallPosition){ // methode suivi de la balle samplée. Chaque balle suit la balle sample avec le meme decalage (deux à deux) spatial et temporel.


    this.phases[0][frameCount % nbMaxDelais] = lastBallPosition; // assigne à la phase et à "chaque frame", la phase samplée. // ici lastBall position
    // nbMaxDelais n'est pas utilisée.nbMaxDelais Est le temps (le nombre de frame) maximal entre l'ensemble des balles. Si il y a 1 frame de decalalage entre chaque balle
    // si y a 10 balles, alors et qu'on veut 10 frames entre chaque balle, alors il y a 90  frame entre la balle 0 et la 9.
    //Si nbMaxDelais=90 alors on ne peut pas avoir plus de 10 frames entre chaque balle
    
    this.drawBall(0, phases[0][frameCount % nbMaxDelais] );

    for (int i = 1; i < this.nbBalls; i++) 
    {
        // la boule 0 n'est pas affichée
        // la boule 1 suit la boule 0 avec 1 frame d'écart 
        // si on a deux frame de decalage et PI/4 de decalage spatial alors entre la balle 6 et la balle 0,
        // on aura 5*2 frame de declage avant que la balle 6 suive la balle 0 et 5 * PI/4 entre la balle 0 et la balle 6 
        
       this.follow( i-1, i, 1 * i, 0);  // Modifier les deux derniers paramètres : délais et phase . 
        // Ici le premier parametre 1*i decale dans le TEMPS le suivi des balles avec un delai d'une frame * i par rapport à la phase samplée : phases[0][frameCount % nbMaxDelais]
        // Le deuxieme parametrere est l'ecart dans l'ESPACE de phase entre chaque balle. 0, il n'y a pas d'ecart, 1, il y a un ecart de phase. à experimenter!
       this.drawBall(i, phases[i][frameCount % nbMaxDelais] );
        
    }  
 }

  /* 
    display ball on screen
   */
  void drawBall(int n, float phase) 
  { 
        pushMatrix();
        translate(-w2, -h2, -1000);
        noStroke();
        float side = height*0.15*1/this.nbBalls;
        float rayon = width/2; 
        float x = rayon*cos(phase);
        float y = rayon*sin(phase);
        translate (x, y, 200+(50*5*n));  
        colorMode(RGB, 255, 255, 255);
        fill( 0, 255, 0 ); 
        sphere(side*3);
        popMatrix();
    }

    /*
      fonction de suivi par rapport à la balle target dont le mouvement est samplé.. 
    */
    void follow( int target, int follower, int delais, float deltaphase) 
    { 
        // Pour nous la target est la netphase11 dont le mouvement est samplé. 
        int step = frameCount % nbMaxDelais;
        int followedStep = (step + nbMaxDelais - delais) % nbMaxDelais;
        phases[follower][step] = this.diffAngle(phases[target][followedStep] + deltaphase, 0);
    }
    
  /*
    return the difference angle1 - angle2 between two angle between -PI PI
   */
  float diffAngle(float angle1, float angle2)
   { 
        float result = angle1 - angle2;
        while (result > PI) {
            result -= 2 * PI;
        }
        while (result < -PI) {
            result += 2 * PI;
        }
        return result;
    }
}
