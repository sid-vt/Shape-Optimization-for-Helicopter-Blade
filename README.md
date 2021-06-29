# Shape optimization for Helicopter Blade

This project is a graduate level course project prepared to fulfill the course requirement of **AOE 5064 - Structural Optimization**
Under the guidance of **Dr. Robert Canfield - Virginia Tech**
@Kevin T. Krofton Aerospace Engineering
@Virginia Tech

Keywords      | Description
------------- | -------------
E, Pa         | Young’s Modulus
𝜌, kg/m3      | Weight density
b, m          | Width of box cross-section
h, m          | Height of box cross-section
t, m          | upper/lower wall thickness of box cross-section
d, m          | Sidewall thickness of box cross-section
x, m          | coordinate along 1-D cantilever structure
xnp, m        | Location for the nodal point from the origin
xop, m        | Optimum location for the nodal point from the origin
𝑀𝑛, kg       | Lumped mass at the nth grid point
𝑀𝑖∗, kg       | Initial Total Mass
𝛿, m          | Allowable distance from a desired nodal point location
𝑣𝑖            | ith Design Variable
𝑓             | Objective Function
𝑔             | Constraint function
ω             | Rotational velocity
λ             | Eigenvalue
Φ             | Eigenvector
𝑇             | Transpose of a Matrix (superscript)
𝑀            | Mass Matrix
𝑁            | Mode shape functions used to compute displacement in FEM analysis

## Project Description
In structural dynamics, modal analysis is one of the key aspects for studying mechanical vibrations. This project is a study to change the nodal location of the mode shape for a helicopter rotor blade under a given air load criteria. This will be done by varying the lumped masses acting as the design variables to bring the node of a mode shape near to the desired location. This nodal replacement will effect directly on reducing the generalized force acting on the helicopter blade which would result in the minimization of vibration responses. δ is considered as the allowable distance from the desired location, this value is taken as 0.0254 m. This value will be used to set up the constraint function. This nodal location is chosen such a way that the mode shape will be orthogonal to the force distribution.
<image>

This project considers the beam of a total length of 4.90 m and a total of 10 elements in the design. The eight lumped masses placed on grid points 3, 4, 6-11 along the length of the beam. These masses will act as our design variables.

<image>

## Approach to Solving the Structural Design Problem
**Phase 1** corresponds of performing modal analysis and calculating the correct mode shape and computing the required nodal location of the second mode. This is done by solving the eigenvalue equation using Finite Element Method and writing the on code from scratch in MATLAB.

**Phase 2** involves performing sensitivity analysis, to solve this problem it requires solving three sensitivity, first is nodal point sensitivity. As seen in the derivation given by Eq 5, this requires computing two different derivative, slope and eigenvector sensitivity. Computing slope is easy and a simple code to find this value can be written, but for eigenvector sensitivity, I used a simplified approach called Nelson’s method as explained by Eq 6 - Eq 15. While solving we found that there is a need to solve another sensitivity that calls for a another sensitivity computation, eigenvalue sensitivity as given by the derivation of Nelson’s Method.

**Phase 3** involves solving optimization problem. I have written my own code for slp with trust regions and found the optimized value for lumped masses. Then I used Dr. Canfield’s written code ‘slp_trust’ available on MATLAB File Exchange. This code has two features as it is faster than mine and is more credible than mine. This subroutine also includes commands to plot iteration history that shows convergence of constraint and objective function.
<img1>
<img2>

##   Test Approach
###  Verification
Results are obtained using self-designed slp algorithm and results are verified using slp_trust and sqp codes provided with the course by the instructor.

###  Validation
The optimized mass values are validated using the research paper [4] this entire project is based on.

NOTE: For descriptive procedure, derivations and result refer to Final_Report.pdf and Final_presentation.pptx

##   Pseudo Codes
###  optimization_slp_trust.m (Main Program)
    define global variables to save values from different subroutines for plotting purpose
    define lower and upper bound
    define initial design variable
    setup options for optimization slp_trust
    run slp_trust
    plot commands

###  funcs.m
    define delta
    define x0
    run setup.m
    run FEMsolve.m
    run eigenAnalysis.m
    run modalAnalysis
    define objective function
    define constraint functions, create row vector

###  grads.m
    run setup.m
    run FEMsolve.m
    run eigenAnalysis.m
    run modalAnalysis
    run sensitivity
    define gradient of objective function
    define gradient of constraint functions, create row vector

###  setup.m
    define shape functions
    define number of elements
    define material properties
    define connectivity matrix
    define lumped mass vector
    assemble lumped mass vector to a matrix wrt to grid location

###  FEMsolve.m (1D FEM code)
    define empty global stiffness matrix
    define empty global mass matrix
    for i = 1 : #elements
        define global stiffness and mass matrix for single element
        call connectivity matrix
        for j = 1 : #dof
            assemble global stiffness and mass matrix
        end
    end
    combine lumped and consistent mass matrix

###  modalAnalysis.m
    for i = 1 : #elements
        compute deflection (using shape functions and elemental deflection calculated)
        find nodal location (where deflection = 0)
    end
    plot deflection plot

### eigenAnalysis.m
    apply boundary condition
    save stiffness matrix – curtailed
    save mass matrix – curtailed
    compute eigenvectors and eigen values

###  sensitivity.m (Nelson's Method)
    define Mprime
    define lambdaPrime
    define Fprime
    define F
    compute max eigenvector location
    remove that location row and column from all matrix and row vectors
    define V, c, q
    compute phiPrime
    solve for slope
    solve for derivative of deflection wrt to design variable
    solve for derivative of nodal location wrt to design variable

## Refereces
 Markup :
 1. R B Taylor, Helicopter rotor blade design for minimum vibration, Vols. NASA CR-3825, Anaheim: National Aeronautics and Space Administration, Scientific and Technical~…, 1984.
 2. R B Taylor, "Helicopter vibration reduction by rotor blade modal shaping," in Proceedings of the 38th Annual Forum of the American Helicopter Society, 1982, pp. 90--101.
 3. H A R H J I Pritchard, "Sensitivity analysis and optimization of nodal point placement for vibration reduction," Journal of Sound and Vibration,, vol. 2, no. 119, pp. 277-289, 1987.
 4. R B Nelson, "Simplified Calculation of eigenvector derivatives," American Institute of Aeronautics and Astronautics Journal, no. 14, pp. 1201 - 1205, 1976.
         