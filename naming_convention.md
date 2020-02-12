### Goal
Create a document to describe naming conventions for your company machines. 

(Cf. https://en.wikipedia.org/wiki/Naming_convention)

#### Scheme
##### Proposal 1

`Environment`-`Zone-Technology`-`Identifiant`-`Indice`

- Environment : prod, prelive, staging, dev, poc
- Zone: par, stras, ny, bdx, ...
- Technologies: mysql, nginx, haproxy, ...
- Identifiant: api, streaming, maps ...
- Indice: Number in [01;99]

##### Proposal 2 
To be updated

##### Other proposal
- Singular names
- Always lowercase names
- No product name in orchestrators cluster hostnames
- Maximum of 2 elements after zone element
- Environment element always in first position
- Rôle element always in third position