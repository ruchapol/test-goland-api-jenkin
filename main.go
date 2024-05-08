package main

import "github.com/gofiber/fiber/v2"

func main() {
	app := fiber.New()

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("Hello, World!")
	})

	app.Get("/test", func(c *fiber.Ctx) error {
		return c.SendString("Hello, World! test 1234")
	})

	app.Listen(":3000")
}
