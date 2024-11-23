
const supertest = require("supertest");
const app = require("../../api/server"); // Adjust path to server file

let server;

beforeAll(() => {
  server = app.listen(0, () => console.log(`Test server running on port ${server.address().port}`));
});

afterAll(() => {
  server.close(); // Clean up after tests
});

describe("GET /products", () => {
  it("should return a list of products", async () => {
    const request = supertest(server);
    const response = await request.get("/api/products");
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });
});

