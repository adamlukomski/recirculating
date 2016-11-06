module profile2020( h=100 )
linear_extrude(h) {
    union() {
        // external corners
        difference() {
            square(20,center=true);
            square(16,center=true);
            for( angle=[0, 90, 180, 270] )
                rotate( [0,0,angle] )
                    translate( [10,0,0] )
                        square([8,5],center=true);
        }
        // middle part, with a hole
        difference() {
            square( 7, center=true );
            circle( d=3.8, center=true, $fn=10 );
        }
        // diagonal parts
        for( angle = [0,90,180,270] )
        rotate( [0,0,45+angle] )
            translate([7.5,0,0])
                square( [8,2], center=true );
    }
}

profile2020(20);