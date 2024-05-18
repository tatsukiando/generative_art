ArrayList<Particle> particles;

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100);
  particles = new ArrayList<Particle>();
  particles.add(new Particle());
  background(0);
}

void draw() {
  fill(0, 0, 0, 10);
  noStroke();
  rect(0, 0, width, height);

  if (frameCount % 60 == 0) {
    particles.add(new Particle());
  }

  for (int i = 0; i < particles.size(); i++) {
    Particle p = particles.get(i);
    p.update();

    // 他の点との相互作用をチェック
    for (int j = i + 1; j < particles.size(); j++) {
      Particle other = particles.get(j);
      float distance = dist(p.x, p.y, other.x, other.y);
      if (distance < 50) { // 点同士が50ピクセル以下に近づいた時
        if (random(1) < 0.5) {
          p.repel(other);
        } else {
          p.boostSpeed();
          other.boostSpeed();
        }
      }
    }

    p.display();
  }
  
  saveFrame("images/####.png");
  if(frameCount >= 6000){
    exit();
  }
}

class Particle {
  float x, y;
  float vx, vy;
  float speed = 2;
  color col;
  float hue;
  float noiseOffsetX, noiseOffsetY;

  Particle() {
    x = random(width);
    y = random(height);
    vx = 0;
    vy = 0;
    hue = random(360);
    noiseOffsetX = random(1000);
    noiseOffsetY = random(1000);
  }

  void update() {
    hue += 1;
    if (hue > 360) hue = 0;
    col = color(hue, 80, 90);
    vx = map(noise(noiseOffsetX), 0, 1, -speed, speed);
    vy = map(noise(noiseOffsetY), 0, 1, -speed, speed);
    x += vx;
    y += vy;
    noiseOffsetX += 0.01;
    noiseOffsetY += 0.01;
    wrapAround();
  }

  void display() {
    stroke(col);
    strokeWeight(1);
    point(x, y);
  }

  void wrapAround() {
    if (x > width) x = 0;
    if (x < 0) x = width;
    if (y > height) y = 0;
    if (y < 0) y = height;
  }

  void repel(Particle other) {
    float angle = atan2(y - other.y, x - other.x);
    vx = cos(angle) * speed * 1.5; // 速度を増加させて反発させる
    vy = sin(angle) * speed * 1.5;
  }

  void boostSpeed() {
    speed *= 1.005;
    vx *= 1.005;
    vy *= 1.005;
  }
}
