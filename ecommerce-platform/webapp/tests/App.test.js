const request = require("supertest");
const app = require("../../api/server"); // Adjust the path if necessary

let server;

beforeAll((done) => {
  server = app.listen(0, () => {
    console.log(`Test server is running on port ${server.address().port}`);
    done();
  });
});

afterAll((done) => {
  server.close(() => {
    console.log("Test server closed");
    done();
  });
});

describe("Root Route Tests", () => {
  it("GET / should return a 200 status and welcome message", async () => {
    const response = await request(server).get("/");
    expect(response.status).toBe(200);
    expect(response.text).toContain("Welcome"); // Adjust based on actual content
  });
});

describe("Product API Tests", () => {
  it("GET /api/products should return a list of products", async () => {
    const response = await request(server).get("/api/products");
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body.length).toBeGreaterThan(0);
    expect(response.body[0]).toHaveProperty("id"); // Adjust properties as necessary
    expect(response.body[0]).toHaveProperty("name");
  });
});




