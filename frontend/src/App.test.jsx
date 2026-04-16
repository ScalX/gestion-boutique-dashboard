import { render, screen } from "@testing-library/react";
import App from "./App";

test("affiche le titre", () => {
  render(<App />);
  expect(screen.getByText("Gestion Boutique Dashboard")).toBeInTheDocument();
});
