// Damon

#include "core"
#include "math"
#include "bots"

fight() {
// some constants to make the source more readable
  new const FRIEND_WARRIOR = ITEM_FRIEND|ITEM_WARRIOR
  new const ENEMY_WARRIOR = ITEM_ENEMY|ITEM_WARRIOR
  new const ENEMY_GUN = ITEM_ENEMY|ITEM_GUN
// constant that defines the rate of direction changes
  new const float:CHANGE_DIR_TIME = 10.0
// small angle to change direction in front of the walls
  new const float:AVOID_WALL_DIR = (getID()%2 == 0? 0.31415: -0.31415)
// maximum extension of head rotations (all angles are in radians)
  new float:headDir = 1.047
// needed for change of direction countdown
  new float:lastTime = getTime()

  //Si la pared esta a cinco metros empieza a caminar
  //cambiando la direccion del warrior
  //Caso contrario run forest, run!!!
  if(sight() > 5){
    run()
  }else{
    walk()
    rotate(getDirection() + 3.14)
  }
  // Hacemos un disparo inicial
  shootBullet()

  // Si tenemos la energia mayor a 50
  // Y vemos a un enemigo atacamos
  // caso contrario corremos cambiando de posicion
  new item
  new sound
  new float:yaw

  while(true){
    item = 0
    hear(item,sound,yaw)
  if(getEnergy() > 50){
      if(item == ENEMY_WARRIOR) {
        rotate(yaw+getDirection())
        rotateHead(0.0) 
        if(isWalking())
          run()
        if(getGrenadeLoad() > 0) {
          bendTorso(0.5236)
          wait(1.0)
          launchGrenade()
          run()
        } else {
          aim(item)
          if(item != FRIEND_WARRIOR){
            shootBullet()
          }
        }
      }else{
        rotate(getDirection() + 3.14)
        run()
      }
  }else{
    // En el caso de que tengamos menos energia
    // Y vemos a un enemigo, solo caminamos y disparamos
    // Caso contrario debemos de caminar
    if(item == ENEMY_WARRIOR) {
        rotate(yaw+getDirection())
        rotateHead(0.0) 
        if(isRunning()){
          walk()
        }
        if(getGrenadeLoad() > 0) {
          bendTorso(0.5236)
          wait(1.0)
          launchGrenade()
          run()
        } else {
          aim(item)
          if(item != FRIEND_WARRIOR){
            shootBullet()
          }
        }
      }else{
        rotate(getDirection() + 3.14)
        walk()
      }
  }
  }
  
  
  if(getID() == 0) {
    say(1)
  } else {
    new item
    new sound
    new float:yaw
    do {
      item = 0
      hear(item,sound,yaw)
    } while(item != FRIEND_WARRIOR)
    new float:halfTurn = 3.1415
    if(yaw > 0) halfTurn = -halfTurn
    rotate(getDirection()+yaw+halfTurn)
  }
  wait(0.3)
  walk()
  for(;;) {
    new float:thisTime = getTime()
    if(thisTime-lastTime > CHANGE_DIR_TIME) {
      lastTime = thisTime
      new float:randAngle = float(random(3)-1)*1.5758
    } else if(isStanding()) {
      rotate(getDirection()+1.5708)
      wait(1.0)
      walk()
    } else if(sight() < 5.0) {
      rotate(getDirection()+AVOID_WALL_DIR)
    }
    new touched = getTouched()
    if(touched) raise(touched)
    new item = ENEMY_WARRIOR
    new float:dist = 0.0
    new float:yaw
    new float:pitch
    watch(item,dist,yaw,pitch)
    if(item == ENEMY_WARRIOR) {
      rotate(yaw+getDirection())
      bendTorso(pitch)
      bendHead(-pitch)
      rotateHead(0.0)
      if(isWalking())
        run()
      if(getGrenadeLoad() > 0 && dist > 30 && dist < 60) {
        bendTorso(0.5236)
        wait(0.5)
        launchGrenade()
        bendTorso(pitch)
        wait(0.5)
      } else {
        aim(item)
        if(item != FRIEND_WARRIOR)
          shootBullet()
      }
    } else {
      new sound
      dist = hear(item,sound,yaw)
      if(item == ENEMY_GUN) {
        if(isWalking())
          run()
      } else {
        if(isRunning())
          walk()
        rotateHead(headDir)
        if(getHeadYaw() == headDir)
          headDir = -headDir
      }
    }
  }
}

/* main entry */
main() {
  switch(getPlay()) {
    case PLAY_FIGHT: fight()
  }
}

