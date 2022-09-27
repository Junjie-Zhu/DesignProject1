int cord_x=0, cord_y=0;
int cell_length=200;
color c1, c2;

void setup() {
    size(1000, 1000);
    background(0);
    strokeWeight(3);
    c1 = color(int(random(0, 1) * 255), 50, 50);
    c2 = color(int(random(0, 1) * 255), 200, 200);
    // frameRate(0.5);
}

void draw() {

}

void keyPressed() {
    if (key == 'z') {
        background(0);
    }
    if (key == 's') {
        saveFrame("frame-####.png");
    }
    if (key == 'c') {
        for (int w=0; w<5; w++) {
            for (int h=0; h<5; h++) {
                // generate multiple trajectories from upper left to lower right
                int direction;
                cord_x = w * cell_length;
                cord_y = h * cell_length;
                int[] tmp={cord_x, cord_y};
                while (cord_x<=(w+1)*cell_length &&  cord_y<=(h+1)*cell_length) {
                    direction = int(random(0, 3));
                    tmp = lr_rect(cord_x, cord_y, direction, w, h);
                    cord_x = tmp[0];
                    cord_y = tmp[1];
                }

                cord_x = w * cell_length; //initialization for following generating
                cord_y = (h+1) * cell_length;
                tmp[0] = cord_x;
                tmp[1] = cord_y;
                
                while (cord_x<=(w+1)*cell_length &&  cord_y>=h*cell_length) {
                    direction = int(random(2, 5));
                    tmp = ur_rect(cord_x, cord_y, direction, w, h);
                    cord_x = tmp[0];
                    cord_y = tmp[1];
                }

            }
        }
    }
}

int[] lr_rect(int x, int y, int dir, int w, int h) {
    // randomly generate stroke color    
    float seed_x, seed_y;
    seed_x = map(random(0, 1), 0, 1, 0.2, 0.6);
    seed_y = map(random(0, 1), 0, 1, 0.2, 0.6);

    float y_color=map(y, 0, height, 0, 1);
    color c_color=lerpColor(c1, c2, y_color);
    stroke(c_color);
    fill(c_color, int(random(0, 1) * 100));

    // generate rectangle with the random seeds
    rectMode(CORNER);
    int delta_x, delta_y;
    delta_x = int(seed_x * cell_length);
    delta_y = int(seed_y * cell_length);
    if ((x + delta_x) >= (w+1)*cell_length || (y + delta_y) >= (h+1)*cell_length) {
        // rect(x, y, (w+1)*cell_length-x, (h+1)*cell_length-y, 10);
        int[] result={x + delta_x, y + delta_y};
        return result;
    }
    else {
        rect(x, y, delta_x, delta_y);
    }

    // decide new x, y values
    switch (dir) {
        case 0:
            y += delta_y; // lower
            break;
        case 1:
            x += delta_x;
            y += delta_y; // lower right
            break;
        case 2:
            x += delta_x; // right
    }

    int[] result={x, y};
    return result;
}

int[] ur_rect(int x, int y, int dir, int w, int h) {
    // randomly generate stroke color    
    float seed_x, seed_y;
    seed_x = map(random(0, 1), 0, 1, 0.2, 1);
    seed_y = map(random(0, 1), 0, 1, 0.2, 1);

    float y_color=map(y, 0, height, 0, 1);
    color c_color=lerpColor(c1, c2, y_color);
    stroke(c_color);
    fill(c_color, int(random(0, 1) * 100));

    // generate rectangle with the random seeds
    rectMode(CORNERS);
    int delta_x, delta_y;
    delta_x = int(seed_x * cell_length);
    delta_y = int(seed_y * cell_length);
    if ((x + delta_x) >= (w+1)*cell_length || (y - delta_y) <= h*cell_length) {
        // rect(x, y, (w+1)*cell_length, h*cell_length, 10);
        int[] result={x + delta_x, y - delta_y};
        return result;
    }
    else {
        rect(x, y, x + delta_x, y - delta_y);
    }

    // decide new x, y values
    switch (dir) {
        case 2:
            x += delta_x; // right
            break;
        case 3:
            x += delta_x;
            y -= delta_y; // upper right
            break;
        case 4:
            y -= delta_y; // upper
    }

    int[] result={x, y};
    return result;
}