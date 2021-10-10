### Base case performance: 
- Clock count: 734
- Retired instructions 279

## Changelog of Improvements: 
- Moved swap inside `forloop` to reduce instructions & bubbles from `call` and `ret`
- Reordered instructions inside swap to greatly improve clock cycles
- Relocated `irmovq  8, %r10` to eliminate clock cycles for the subsequent `mulq`