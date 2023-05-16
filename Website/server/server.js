const express = require("express");
const app = express();

app.use(express.static("public"));
app.use(express.json());

app.get("/get-details", async (req, res) => {
  const items = req.body;
  console.log(items)
    res.send({
        response: items   
    });
});

app.listen(8080, () => console.log("Node server listening on port 8080!"));